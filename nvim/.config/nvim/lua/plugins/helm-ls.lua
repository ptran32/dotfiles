require("helm-ls").setup({
  conceal_templates = { enabled = true },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "helm",
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})
