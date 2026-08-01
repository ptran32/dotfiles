-- https://github.com/NeogitOrg/neogit — Magit-style Git UI inside Neovim.
-- https://github.com/NeogitOrg/neogit#configuration
require("neogit").setup({
  integrations = {
    codediff = true,
    snacks = true,
  },
  commit_editor = {
    -- Avoid opening a second staged-diff window that is easy to close instead
    -- of submitting the commit message buffer.
    show_staged_diff = false,
  },
  diff_viewer = "codediff",
  mappings = {
    commit_editor = {
      ["<leader>x"] = "Submit",
    },
  },
})

-- `ng` / empty startup leaves a scratch buffer under Neogit's tab; quitting
-- status would otherwise land on that empty window. Exit Neovim when nothing
-- meaningful remains (keep sessions that still have files or a dashboard).
local function should_quit_after_neogit()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.bo[buf].filetype
      if ft == "snacks_dashboard" or ft == "alpha" or ft == "dashboard" then
        return false
      end
      if vim.bo[buf].buflisted then
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= "" or vim.bo[buf].modified then
          return false
        end
      end
    end
  end
  return true
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "NeogitStatus",
  callback = function(ev)
    vim.api.nvim_create_autocmd("BufWipeout", {
      buffer = ev.buf,
      once = true,
      callback = function()
        vim.schedule(function()
          if should_quit_after_neogit() then
            vim.cmd("qa!")
          end
        end)
      end,
    })
  end,
})

local function open_neogit()
  require("neogit").open()
end

vim.api.nvim_create_user_command("OpenNeogit", open_neogit, {})
vim.keymap.set("n", "<leader>ng", open_neogit, { desc = "Neogit" })
