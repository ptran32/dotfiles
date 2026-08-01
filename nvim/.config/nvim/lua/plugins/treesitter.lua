require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    require("nvim-treesitter").install({
      "bash",
      "dockerfile",
      "helm",
      "lua",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "terraform",
      "vim",
      "vimdoc",
      "yaml",
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "bash",
    "dockerfile",
    "helm",
    "lua",
    "nix",
    "python",
    "terraform",
    "yaml",
    "vim",
  },
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
