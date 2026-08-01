-- splitjoin.nvim - split/join list-like syntax constructs under the cursor.
-- https://github.com/bennypowers/splitjoin.nvim
require("splitjoin").setup()

vim.keymap.set("n", "sj", function()
  require("splitjoin").toggle()
end, { desc = "Toggle split/join construct" })
