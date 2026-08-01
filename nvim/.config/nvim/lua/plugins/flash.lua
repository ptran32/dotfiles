-- flash.nvim — jump by typing + labels. https://github.com/folke/flash.nvim
-- Jump on f (not s) so mini.surround can keep its default s… mappings.
-- Char mode (enhanced f/t/F/T) is off: it also binds f and left a stuck "f" label.
require("flash").setup({
  modes = {
    char = {
      enabled = false,
    },
  },
  label = {
    -- Put the letter before the match so it is obvious (not overlaid on the text).
    before = true,
    after = false,
    style = "inline",
    rainbow = {
      enabled = true,
      shade = 5,
    },
  },
  highlight = {
    backdrop = true,
    matches = true,
  },
})

-- Loud labels — theme links (Comment/Substitute) are too easy to miss.
local function flash_highlights()
  vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#6c7086" })
  vim.api.nvim_set_hl(0, "FlashMatch", { bg = "#89b4fa", fg = "#1e1e2e", bold = true })
  vim.api.nvim_set_hl(0, "FlashCurrent", { bg = "#fab387", fg = "#1e1e2e", bold = true })
  vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#f38ba8", fg = "#1e1e2e", bold = true })
end
flash_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("flash-highlights", { clear = true }),
  callback = flash_highlights,
})

local map = vim.keymap.set
map({ "n", "x", "o" }, "f", function()
  require("flash").jump()
end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })
map("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })
map({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
map("c", "<c-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })
