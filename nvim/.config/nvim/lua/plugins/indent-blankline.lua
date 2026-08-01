-- Indent guides — colors from active colorscheme (home/nvim/plugins/themes.lua).
require("ibl").setup({
  indent = {
    char = "┊",
    tab_char = "┊",
  },
  scope = {
    char = "▎",
    show_start = false,
    show_end = false,
  },
})
