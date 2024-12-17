-- auto-format on save
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format({ timeout_ms = 6000 })]])

-- set textwidth to 80 for Markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		vim.opt_local.textwidth = 80
	end,
})
