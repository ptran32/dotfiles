-- nvim-autopairs: auto-insert bracket/quote pairs. https://github.com/windwp/nvim-autopairs
require("nvim-autopairs").setup({
  check_ts = true,
  disable_filetype = { "TelescopePrompt", "lazy", "snacks_picker_input" },
  -- Avoid interfering with blink.cmp's completion menu.
  enable_check_bracket_line = false,
})
