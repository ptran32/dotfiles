-- sniprun - run the current line, visual selection, or motion as a quick snippet.
-- https://github.com/michaelb/sniprun
require("sniprun").setup({
  display = {
    "TempFloatingWindow",
  },
  live_display = { "VirtualTextOk" },
  borders = "single",
})

local keymaps = {
  { { "n", "x" }, "<leader>rs", "<Plug>SnipRun", "Run snippet" },
  { "n", "<leader>rS", "<Plug>SnipRunOperator", "Run snippet operator" },
  { "n", "<leader>ri", function() vim.cmd.SnipInfo() end, "SnipRun info" },
  { "n", "<leader>rX", function() vim.cmd.SnipReset() end, "Reset SnipRun jobs" },
  { "n", "<leader>rL", function() vim.cmd.SnipLive() end, "Toggle SnipRun live mode" },
}

for _, map in ipairs(keymaps) do
  local opts = { desc = map[4], silent = true }
  if type(map[3]) == "string" then
    opts.remap = true
  end
  vim.keymap.set(map[1], map[2], map[3], opts)
end
