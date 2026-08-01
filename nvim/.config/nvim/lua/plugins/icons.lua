-- mini.icons — modern file/LSP icons; mocks nvim-web-devicons for snacks.nvim et al.
-- https://github.com/nvim-mini/mini.icons
local MiniIcons = require("mini.icons")

MiniIcons.setup({
  style = "glyph",
})

MiniIcons.mock_nvim_web_devicons()
