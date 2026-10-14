local function config(file)
  return function()
    require("plugins." .. file)
  end
end

return {
  { "echasnovski/mini.icons", config = config("icons") },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("config.snacks-setup")
      require("plugins.snacks-keymaps")
    end,
  },
  {
    "Aejkatappaja/sora",
    tag = "v1.4.0",
    config = config("themes"),
  },
  { "nvim-lua/plenary.nvim" },
  { "folke/which-key.nvim", config = config("which-key") },
  { "lewis6991/gitsigns.nvim", config = config("gitsigns") },
  { "tpope/vim-fugitive" },
  { "vim-airline/vim-airline", dependencies = { "vim-airline/vim-airline-themes" }, config = config("airline") },
  { "numToStr/Comment.nvim", config = config("comment") },
  { "rafamadriz/friendly-snippets" },
  { "Saghen/blink.cmp", version = "*", dependencies = { "rafamadriz/friendly-snippets" }, config = config("blink-cmp") },
  { "windwp/nvim-autopairs", config = config("nvim-autopairs") },
  { "abecodes/tabout.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" }, config = config("tabout") },
  { "echasnovski/mini.surround", config = config("mini-surround") },
  { "folke/flash.nvim", config = config("flash") },
  { "neovim/nvim-lspconfig", config = config("lsp") },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = config("treesitter") },
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    config = config("markdown-preview"),
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", config = config("indent-blankline") },
  { "qvalentin/helm-ls.nvim", config = config("helm-ls") },
  { "MagicDuck/grug-far.nvim", config = config("grug-far") },
  { "bennypowers/splitjoin.nvim", config = config("splitjoin") },
  { "michaelb/sniprun", build = "bash ./install.sh", config = config("sniprun") },
  { "nvzone/volt" },
  { "gisketch/triforce.nvim", dependencies = { "nvzone/volt" }, config = config("triforce") },
  { "CRAG666/code_runner.nvim", config = config("code_runner") },
  { "esmuellert/codediff.nvim", config = config("codediff") },
  { "NeogitOrg/neogit", dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "esmuellert/codediff.nvim" }, config = config("neogit") },
}
