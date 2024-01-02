local map = require("util.keymapper").map

local M = {}

M.on_attach = function(_, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	map("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", "Show LSP references", opts)

	map("n", "<leader>gd", vim.lsp.buf.definition, "Go to definition", opts)

	map("n", "<leader>ca", vim.lsp.buf.code_action, "See available code actions", opts)

	map("n", "<leader>sr", vim.lsp.buf.rename, "Smart rename", opts)

	map("n", "<leader>ld", vim.diagnostic.open_float, "Show line diagnostics", opts)

	map("n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic", opts)

	map("n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic", opts)

	map("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor", opts)
end

return M
