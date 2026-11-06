-- https://github.com/esmuellert/codediff.nvim
-- VS Code-style diffs and three-way merge support for Neogit.

-- The plugin is installed in a read-only Nix store path. Prevent its optional
-- watcher installer from trying to write beside that path; CodeDiff falls back
-- to its built-in polling watcher.
vim.env.CODEDIFF_WATCHER_NO_AUTO_INSTALL = "1"

require("codediff").setup({
  diff = {
    conflict_result_position = "center",
    conflict_ours_position = "left",
  },
  explorer = {
    width = 20,
  },
  keymaps = {
    view = {
      next_hunk = "]]",
      prev_hunk = "[[",
    },
    conflict = {
      accept_incoming = "<leader>co",
      accept_current = "<leader>ct",
      diffget_incoming = "gl",
      diffget_current = "gr",
      next_conflict = "]c",
      prev_conflict = "[c",
    },
  },
})
