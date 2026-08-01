-- YAML/Helm and JSON use 2-space indent; Vim defaults (tabstop=8, no expandtab) look wrong.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml", "helm", "helmfile", "json", "jsonc" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
