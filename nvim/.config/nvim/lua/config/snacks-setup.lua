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
    -- No "startup" section: it requires lazy.nvim (`lazy.stats`).
    preset = {
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
        { icon = "󰙅 ", key = "e", desc = "Explorer", action = ":lua Snacks.explorer()" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 2 } },
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
      {
        icon = " ",
        title = "Git Status",
        section = "terminal",
        enabled = function()
          return Snacks.git.get_root() ~= nil
        end,
        cmd = "git --no-optional-locks status --short --branch --renames",
        height = 8,
        padding = 1,
        ttl = 5 * 60,
        indent = 2,
      },
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
