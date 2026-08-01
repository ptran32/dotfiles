-- https://github.com/esmuellert/codediff.nvim
-- VS Code-style diffs + 3-way merge tool. Neogit diff_viewer = "codediff".

require("codediff").setup({
  diff = {
    -- Three columns: Current (ours/:2) | Result | Incoming (theirs/:3).
    conflict_result_position = "center",
    conflict_ours_position = "left",
  },
  explorer = {
    -- Default is 40; half that so diffs get more horizontal space.
    width = 20,
  },
  keymaps = {
    view = {
      next_hunk = "]]",
      prev_hunk = "[[",
    },
    conflict = {
      -- With ours-left, Neogit puts :2 in "original" and :3 in "modified".
      -- Flip accept_* so <leader>co = ours and <leader>ct = theirs still hold.
      accept_incoming = "<leader>co", -- original buffer = ours (left)
      accept_current = "<leader>ct", -- modified buffer = theirs (right)
      -- From Result (middle) only. Avoid Vim's native 2do/3do (:diffget), which
      -- needs 'diff' mode and errors with "not in diff mode" in CodeDiff.
      -- Also aliased to <leader>[ / <leader>] below (gl/gr kept).
      diffget_incoming = "gl", -- get left (target / ours)
      diffget_current = "gr", -- get right (remote / theirs)
      next_conflict = "]]",
      prev_conflict = "[[",
    },
  },
})

-- Upstream can compute conflict result_range past the Result buffer length,
-- which makes nvim_buf_set_extmark throw Invalid 'end_row': out of range
-- (codediff/ui/conflict/tracking.lua). Clamp ranges before tracking.
local tracking = require("codediff.ui.conflict.tracking")
local initialize_tracking = tracking.initialize_tracking

tracking.initialize_tracking = function(result_bufnr, conflict_blocks)
  if result_bufnr and vim.api.nvim_buf_is_valid(result_bufnr) and conflict_blocks then
    local line_count = vim.api.nvim_buf_line_count(result_bufnr)
    for _, block in ipairs(conflict_blocks) do
      local range = block.result_range or block.base_range
      if range and range.start_line and range.end_line then
        -- Extmark rows are 0-based; ranges here are 1-based [start, end).
        local max_end = line_count + 1
        range.start_line = math.max(1, math.min(range.start_line, line_count))
        range.end_line = math.max(range.start_line, math.min(range.end_line, max_end))
      end
    end
  end

  local ok, err = pcall(initialize_tracking, result_bufnr, conflict_blocks)
  if not ok then
    vim.notify("[codediff] conflict tracking failed: " .. tostring(err), vim.log.levels.WARN)
  end
end

-- CodeDiff seeds Result with an auto-merged draft, then forces modified=true.
-- That makes `q` warn even with no edits, and a later view refresh can re-seed
-- after `:w` and dirty the buffer again. Treat the seed as a clean baseline,
-- skip clobbering an already-saved Result on update, and clear tracking on write.
local conflict_window = require("codediff.ui.view.conflict_window")
local lifecycle = require("codediff.ui.lifecycle")
local accessors = require("codediff.ui.lifecycle.accessors")
local setup_conflict_result_window = conflict_window.setup_conflict_result_window

local function same_path(a, b)
  return vim.fn.fnamemodify(a, ":p") == vim.fn.fnamemodify(b, ":p")
end

local function lines_equal(a, b)
  if a == b then
    return true
  end
  if type(a) ~= "table" or type(b) ~= "table" or #a ~= #b then
    return false
  end
  for i = 1, #a do
    if a[i] ~= b[i] then
      return false
    end
  end
  return true
end

local function mark_result_clean(bufnr)
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    vim.bo[bufnr].modified = false
  end
end

local function focus_result(result_win)
  if result_win and vim.api.nvim_win_is_valid(result_win) then
    vim.api.nvim_set_current_win(result_win)
  end
end

-- Only warn on quit when Result differs from the auto-merge seed (real edits).
-- Upstream tracks modified=true for the seed itself, which falsely trips `q`.
accessors.get_unsaved_conflict_files = function(tabpage)
  local session = lifecycle.get_session(tabpage)
  if not session or not session.conflict_files then
    return {}
  end

  local seed = session.result_base_lines
  local result_bufnr = session.result_bufnr
  local unsaved = {}

  for file_path, _ in pairs(session.conflict_files) do
    local bufnr = -1
    if result_bufnr and vim.api.nvim_buf_is_valid(result_bufnr) then
      if same_path(vim.api.nvim_buf_get_name(result_bufnr), file_path) then
        bufnr = result_bufnr
      end
    end
    if bufnr == -1 then
      bufnr = vim.fn.bufnr(file_path)
    end

    if bufnr ~= -1 and vim.api.nvim_buf_is_valid(bufnr) then
      if seed and bufnr == result_bufnr then
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        if not lines_equal(lines, seed) then
          table.insert(unsaved, file_path)
        end
      elseif vim.bo[bufnr].modified then
        table.insert(unsaved, file_path)
      end
    end
  end

  return unsaved
end
-- Keep lifecycle export in sync with the patched accessor.
lifecycle.get_unsaved_conflict_files = accessors.get_unsaved_conflict_files

conflict_window.setup_conflict_result_window = function(
  tabpage,
  session_config,
  original_win,
  modified_win,
  base_lines,
  conflict_diffs,
  is_update
)
  local abs_path = session_config.git_root .. "/" .. session_config.original_path

  if is_update then
    local existing_bufnr, existing_win = lifecycle.get_result(tabpage)
    if
      existing_bufnr
      and vim.api.nvim_buf_is_valid(existing_bufnr)
      and existing_win
      and vim.api.nvim_win_is_valid(existing_win)
      and same_path(vim.api.nvim_buf_get_name(existing_bufnr), abs_path)
    then
      -- Keep the user's Result (saved or in-progress). Re-seeding would overwrite
      -- resolutions and force modified=true again after `:w`.
      -- Upstream conflict render focuses the right pane before this runs; reclaim Result.
      focus_result(existing_win)
      vim.schedule(function()
        focus_result(existing_win)
        mark_result_clean(existing_bufnr)
      end)
      return true
    end
  end

  local success = setup_conflict_result_window(
    tabpage,
    session_config,
    original_win,
    modified_win,
    base_lines,
    conflict_diffs,
    is_update
  )
  if not success then
    return false
  end

  local result_bufnr, result_win = lifecycle.get_result(tabpage)
  -- Auto-merge seed is intentional starting content, not user edits.
  mark_result_clean(result_bufnr)
  -- Upstream returns focus to modified (right); keep cursor in Result (middle).
  -- Schedule again so we win races with jump-to-first-hunk / view.update.
  focus_result(result_win)
  vim.schedule(function()
    mark_result_clean(result_bufnr)
    focus_result(result_win)
  end)
  return true
end

-- side_by_side.lua binds setup_conflict_result_window into a local at require-time,
-- often before this config runs. Rebind that upvalue so our wrapper actually runs.
local function replace_upvalue(fn, name, value)
  local i = 1
  while true do
    local uname = debug.getupvalue(fn, i)
    if not uname then
      return false
    end
    if uname == name then
      debug.setupvalue(fn, i, value)
      return true
    end
    i = i + 1
  end
end

local side_by_side = require("codediff.ui.view.side_by_side")
if not replace_upvalue(side_by_side.create, "setup_conflict_result_window", conflict_window.setup_conflict_result_window) then
  vim.notify(
    "[codediff] could not rebind setup_conflict_result_window; Result focus/clean patches inactive",
    vim.log.levels.WARN
  )
end

-- Extra conflict shortcuts (originals kept: gl/gr, <leader>cb).
local conflict = require("codediff.ui.conflict")
local conflict_tracking = require("codediff.ui.conflict.tracking")
local conflict_diffget = require("codediff.ui.conflict.diffget")
local conflict_actions = require("codediff.ui.conflict.actions")
local setup_conflict_keymaps = conflict.setup_keymaps

-- accept_*/discard only look at left/right panes. With Result focused (middle),
-- resolve the conflict via result extmarks, then run the action from the left pane.
local function find_result_conflict(session, cursor_line, allow_resolved)
  if allow_resolved then
    for _, block in ipairs(session.conflict_blocks or {}) do
      if block.extmark_id then
        local mark = vim.api.nvim_buf_get_extmark_by_id(
          session.result_bufnr,
          conflict_tracking.tracking_ns,
          block.extmark_id,
          { details = true }
        )
        if mark and #mark > 0 then
          local start_row = mark[1] + 1
          local end_row = mark[3] and mark[3].end_row and (mark[3].end_row + 1) or start_row
          if cursor_line >= start_row and cursor_line <= end_row then
            return block
          end
        end
      end
    end
    return nil
  end
  return conflict_tracking.find_conflict_at_cursor_in_result(session, cursor_line)
end

local function with_result_cursor_support(action, allow_resolved)
  return function(tabpage)
    local session = lifecycle.get_session(tabpage)
    if not session or vim.api.nvim_get_current_buf() ~= session.result_bufnr then
      return action(tabpage)
    end

    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
    local block = find_result_conflict(session, cursor_line, allow_resolved)
    if not block then
      vim.notify(
        allow_resolved and "[codediff] No conflict at cursor position"
          or "[codediff] No active conflict at cursor position",
        vim.log.levels.INFO
      )
      return false
    end

    local target_win = session.original_win
    local range = block.output1_range
    if not target_win or not vim.api.nvim_win_is_valid(target_win) or not range then
      vim.notify("[codediff] Cursor not in diff buffer", vim.log.levels.WARN)
      return false
    end

    local saved_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(target_win)
    pcall(vim.api.nvim_win_set_cursor, target_win, { math.max(1, range.start_line), 0 })
    local ok = action(tabpage)
    if vim.api.nvim_win_is_valid(saved_win) then
      vim.api.nvim_set_current_win(saved_win)
    end
    return ok
  end
end

conflict_actions.accept_incoming = with_result_cursor_support(conflict_actions.accept_incoming, false)
conflict_actions.accept_current = with_result_cursor_support(conflict_actions.accept_current, false)
conflict_actions.accept_both = with_result_cursor_support(conflict_actions.accept_both, false)
conflict_actions.discard = with_result_cursor_support(conflict_actions.discard, true)
conflict.accept_incoming = conflict_actions.accept_incoming
conflict.accept_current = conflict_actions.accept_current
conflict.accept_both = conflict_actions.accept_both
conflict.discard = conflict_actions.discard

conflict.setup_keymaps = function(tabpage)
  setup_conflict_keymaps(tabpage)

  local session = lifecycle.get_session(tabpage)
  if not session then
    return
  end

  local result_bufnr = session.result_bufnr
  local buffers = { session.original_bufnr, session.modified_bufnr, result_bufnr }
  local base_opts = { noremap = true, silent = true, nowait = true }

  for _, bufnr in ipairs(buffers) do
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      vim.keymap.set(
        "n",
        "<leader>=",
        conflict_tracking.make_repeatable(function()
          conflict_actions.accept_both(tabpage)
        end),
        vim.tbl_extend("force", base_opts, {
          buffer = bufnr,
          desc = "Accept both changes",
          expr = true,
        })
      )

      if bufnr == result_bufnr then
        local opts = vim.tbl_extend("force", base_opts, { buffer = bufnr, expr = true })
        vim.keymap.set(
          "n",
          "<leader>[",
          conflict_tracking.make_repeatable(function()
            conflict_diffget.diffget_incoming(tabpage)
          end),
          vim.tbl_extend("force", opts, { desc = "Get hunk from left (ours)" })
        )
        vim.keymap.set(
          "n",
          "<leader>]",
          conflict_tracking.make_repeatable(function()
            conflict_diffget.diffget_current(tabpage)
          end),
          vim.tbl_extend("force", opts, { desc = "Get hunk from right (theirs)" })
        )
      end
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("codediff-clear-saved-conflict", { clear = true }),
  callback = function(args)
    local session = lifecycle.get_session(vim.api.nvim_get_current_tabpage())
    if not session or not session.conflict_files then
      return
    end

    local written = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ":p")
    for path, _ in pairs(session.conflict_files) do
      if same_path(path, written) then
        session.conflict_files[path] = nil
      end
    end
    vim.bo[args.buf].modified = false
  end,
})
