local map = require("utils.keymapper").map

local lsp_group = vim.api.nvim_create_augroup("lspgroup", { clear = false })

vim.lsp.config("*", {
	capabilities = {
		textDocument = {
			semanticTokens = {
				multilineTokenSupport = true,
			},
		},
	},
	root_markers = { ".git" },
})

vim.lsp.config("lua_ls", require("lsp.luals"))

vim.lsp.config("clangd", require("lsp.clangd"))

vim.lsp.config("gopls", require("lsp.gopls"))

vim.lsp.config("pyright", require("lsp.pyright"))

vim.lsp.config("html", require("lsp.htmlls"))

vim.lsp.config("css", require("lsp.cssls"))

vim.lsp.config("ts_ls", require("lsp.tsls"))

vim.lsp.config("tailwind_ls", require("lsp.tailwindls"))

vim.lsp.config("rust_analyzer", require("lsp.rustanalyzer"))

vim.lsp.config("bash_ls", require("lsp.bashls"))

vim.lsp.enable({
	"lua_ls",
	"gopls",
	"clangd",
	"pyright",
	"html",
	"css",
	"ts_ls",
	"rust_analyzer",
	"bash_ls",
	"tailwind_ls",
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function()
		map("n", "<leader>gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "<leader>ca", vim.lsp.buf.code_action, "See available code actions")
		map("n", "<leader>sr", vim.lsp.buf.rename, "Smart rename")
		map("n", "<leader>ld", vim.diagnostic.open_float, "Show line diagnostics")
		map("n", "[d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Go to previous diagnostic")
		map("n", "]d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Go to next diagnostic")
		map("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor")
	end,
})

vim.diagnostic.config({
	virtual_text = false,
	underline = false,
	update_in_insert = false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E ",
			[vim.diagnostic.severity.WARN] = "W ",
			[vim.diagnostic.severity.INFO] = "I ",
			[vim.diagnostic.severity.HINT] = "H ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})
