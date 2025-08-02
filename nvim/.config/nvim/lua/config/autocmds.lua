-- auto-format on save
vim.cmd([[autocmd BufWritePre * lua if vim.g.autoformat then vim.lsp.buf.format({ timeout_ms = 6000 }) end]])

-- set textwidth to 100 for Markdown and Typst files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "typst" },
	callback = function()
		vim.opt_local.textwidth = 100
	end,
})

-- highlight on yank
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})
