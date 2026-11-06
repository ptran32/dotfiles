-- Copy helpers for agent CLIs (@file and @file:line-range context).
-- Does not change normal yank (y) or clipboard=unnamedplus behavior.

local highlight_ns = vim.api.nvim_create_namespace("cursor-agent-copy")

local function workspace_relative_path(abs_path)
  if abs_path == "" then
    return nil
  end

  local dir = vim.fs.dirname(abs_path)
  local root = vim.trim(vim.fn.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }, ""))
  if vim.v.shell_error ~= 0 or root == "" then
    root = vim.fn.getcwd()
  end

  return vim.fs.relpath(root, abs_path) or vim.fn.fnamemodify(abs_path, ":.")
end

local function selection_range()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    return start_line, end_line
  end

  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  if start_line > 0 and end_line > 0 then
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    return start_line, end_line
  end

  local line = vim.fn.line(".")
  return line, line
end

local function highlight_copied()
  if vim.fn.mode():find("^[vV\22]") then
    vim.hl.on_yank({ timeout = 300, on_visual = true })
    return
  end

  local start_line, end_line = selection_range()
  vim.hl.range(0, highlight_ns, "IncSearch", { start_line - 1, 0 }, { end_line - 1, -1 }, { timeout = 300 })
end

local function copy_file_ref()
  local abs_path = vim.api.nvim_buf_get_name(0)
  if abs_path == "" then
    vim.notify("Buffer has no file path", vim.log.levels.ERROR)
    return
  end

  local path = workspace_relative_path(abs_path)
  vim.fn.setreg("+", "@" .. path)
  vim.notify("Copied: @" .. path, vim.log.levels.INFO)
end

local function copy_for_agent()
  local abs_path = vim.api.nvim_buf_get_name(0)
  if abs_path == "" then
    vim.notify("Buffer has no file path", vim.log.levels.ERROR)
    return
  end

  local path = workspace_relative_path(abs_path)
  local start_line, end_line = selection_range()
  local ref = "@" .. path
  if start_line == end_line then
    ref = ref .. ":" .. start_line
  else
    ref = ref .. ":" .. start_line .. "-" .. end_line
  end

  vim.fn.setreg("+", ref)
  vim.notify("Copied for agent: " .. ref, vim.log.levels.INFO)
  highlight_copied()

  if vim.fn.mode():find("^[vV\22]") then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end

vim.keymap.set("n", "<leader>cp", copy_file_ref, { desc = "Copy workspace-relative @file ref for agents" })
vim.keymap.set({ "n", "x" }, "<leader>ca", copy_for_agent, { desc = "Copy workspace-relative @file:lines for agents" })

