-- triforce.nvim: XP, levels, achievements. https://github.com/gisketch/triforce.nvim
-- Upstream default keymap is disabled (show_profile = ''); README documents <leader>tp.
require("triforce").setup({
  keymap = {
    show_profile = "<leader>tp",
  },
})
