-- auto-format on save
vim.cmd([[autocmd BufWritePre * lua if vim.g.autoformat then vim.lsp.buf.format({ timeout_ms = 6000 }) end]])

-- set textwidth to 100 for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.textwidth = 100
  end,
})
