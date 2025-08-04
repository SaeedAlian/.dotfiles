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

vim.lsp.config("rust_analyzer", require("lsp.rustanalyzer"))

vim.lsp.config("bash_ls", require("lsp.bashls"))

vim.lsp.enable({ "lua_ls", "gopls", "clangd", "pyright", "html", "css", "ts_ls", "rust_analyzer", "bash_ls" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(args)
		map("n", "<leader>gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "<leader>ca", vim.lsp.buf.code_action, "See available code actions")
		map("n", "<leader>sr", vim.lsp.buf.rename, "Smart rename")
		map("n", "<leader>ld", vim.diagnostic.open_float, "Show line diagnostics")
		map("n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
		map("n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic")
		map("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor")

		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client and client:supports_method("textDocument/completion") then
			-- trigger autocompletion on every keypress (may be slow!)
			local chars = {}
			for i = 32, 126 do
				table.insert(chars, string.char(i))
			end
			client.server_capabilities.completionProvider.triggerCharacters = chars

			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

			-- set colors for pmenu
			vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1f2335", fg = "#c0caf5" })
			vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#7aa2f7", fg = "#1f2335" })
			vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#292e42" })
			vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#7aa2f7" })

			-- set width and height of pmenu
			vim.opt.pumheight = 12
			vim.opt.pumwidth = 5

			-- keybinds for autocompletion menu
			map("i", "<C-Space>", function()
				vim.lsp.completion.get()
			end, "Trigger autocompletion menu")

			map("i", "<C-j>", function()
				return vim.fn.pumvisible() and ("<C-n>" or "<Down>")
			end, "Select next in the autocompletion menu", { expr = true, noremap = true })

			map("i", "<C-k>", function()
				return vim.fn.pumvisible() and ("<C-p>" or "<Up>")
			end, "Select previous in the autocompletion menu", { expr = true, noremap = true })

			map("i", "<C-e>", function()
				if vim.fn.pumvisible() then
					return "<C-Y>"
				end
			end, "Select next in the autocompletion menu", { expr = true, noremap = true })
		end
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
