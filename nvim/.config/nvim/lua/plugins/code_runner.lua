-- code_runner.nvim — run current file in a floating terminal popup.
-- https://github.com/CRAG666/code_runner.nvim
require("code_runner").setup({
  mode = "float",
  startinsert = true,
  float = {
    border = "rounded",
    height = 0.35,
    width = 0.85,
    x = 0.5,
    y = 0.92,
  },
  filetype = {
    python = "python3 -u",
    sh = "bash",
    bash = "bash",
    zsh = "zsh",
    lua = "lua",
  },
})

-- Enter terminal-insert mode when the float runner opens (TermOpen fires after
-- the PTY is ready; startinsert alone can race on Neovim 0.11+ jobstart).
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    if vim.bo.filetype == "crunner" then
      vim.cmd.startinsert()
    end
  end,
})

local function run_code()
  vim.cmd.RunCode()
end

local function save_and_run()
  if vim.bo.modified then
    vim.cmd.write()
  end
  run_code()
end

local keymaps = {
  { "n", "<leader><space>", run_code, "Run code (filetype/project)" },
  { "n", "<leader>wr", save_and_run, "Save and run code" },
  { "n", "<leader>rf", function() vim.cmd.RunFile() end, "Run current file" },
  { "n", "<leader>rc", function() vim.cmd.RunClose() end, "Close code runner" },
  { "n", "<leader>rp", function() vim.cmd.RunProject() end, "Run project command" },
}

for _, map in ipairs(keymaps) do
  vim.keymap.set(map[1], map[2], map[3], { desc = map[4], silent = true })
end
