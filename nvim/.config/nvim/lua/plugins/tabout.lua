-- tabout.nvim: jump out of quotes/brackets/parens from insert mode.
-- Keep Tab for blink.cmp and use home-row-friendly Ctrl-j / Ctrl-k instead.
require("tabout").setup({
  tabkey = "<C-k>",
  backwards_tabkey = "<C-j>",
  act_as_tab = false,
  act_as_shift_tab = false,
  completion = false,
  ignore_beginning = true,
})
