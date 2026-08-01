vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Could not install lazy.nvim. Check that git and network access are available.\n" .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("plugins"), {
  checker = { enabled = true },
  change_detection = { notify = false },
})

require("config.neovim")
require("config.yaml-indent")
