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

local function open_neogit()
  require("neogit").open()
end

vim.api.nvim_create_user_command("OpenNeogit", open_neogit, {})
vim.keymap.set("n", "<leader>ng", open_neogit, { desc = "Neogit" })
