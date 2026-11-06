if vim.loader then
  vim.loader.enable()
end

-- snacks.nvim setup — load early via initLua (see home/default.nix).
-- Leader must be set before plugin keymaps register.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Upstream docs assume lazy.nvim; this config adapts for Home Manager.
-- https://github.com/folke/snacks.nvim
local Snacks = require("snacks")

Snacks.setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    sections = {
      function(self)
        local art_width = 24 -- pikachu sprite is ~21 display cols
        return {
          section = "terminal",
          -- tail keeps the job alive so Neovim never prints "[Process exited 0]"
          cmd = "pokemon-colorscripts -n pikachu --no-title; tail -f /dev/null",
          height = 12,
          width = art_width,
          indent = math.max(0, math.floor((self.opts.width - art_width) / 2)),
          padding = { 2, 1 },
        }
      end,
    },
  },
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        hidden = true,
      },
      projects = {
        dev = { "~/git" },
        recent = true,
        confirm = { "tcd", "picker_explorer" },
      },
    },
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  gh = { enabled = true },
  zen = {
    -- Keep all text at its normal brightness instead of highlighting only the current scope.
    toggles = {
      dim = false,
      git_signs = false,
      mini_diff_signs = false,
    },
  },
  styles = {
    notification = {
      -- wo = { wrap = true },
    },
  },
})
