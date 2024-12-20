local UpdateMarkdownPreview = require("util.markdown").UpdateMarkdownPreview

-- auto-format on save
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format({ timeout_ms = 6000 })]])

-- update markdown preview on save if there is already a preview
vim.cmd([[autocmd BufWritePost *.md lua UpdateMarkdownPreview()]])

-- set textwidth to 80 for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})
