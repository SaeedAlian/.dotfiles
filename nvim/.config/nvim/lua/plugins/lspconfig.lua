local on_attach = require("util.lsp").on_attach
local diagnostic_signs = require("util.icons").diagnostic_signs

local config = function()
	require("neoconf").setup({})

	local lspconfig = require("lspconfig")
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local capabilities = cmp_nvim_lsp.default_capabilities()

	-- set diagnostics icons
	for type, icon in pairs(diagnostic_signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	-- html
	lspconfig["html"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- typescript
	lspconfig["tsserver"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- css
	lspconfig["cssls"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- tailwindcss
	lspconfig["tailwindcss"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- svelte
	lspconfig["svelte"].setup({
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)

			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*.js", "*.ts" },
				callback = function(ctx)
					if client.name == "svelte" then
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
					end
				end,
			})
		end,
	})

	-- prisma
	lspconfig["prismals"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- python
	lspconfig["pyright"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- bash
	lspconfig["bashls"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- rust
	lspconfig["rust_analyzer"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- c\c++
	lspconfig["clangd"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "cpp", "c", "h", "hpp", "cc" },
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
		},
	})

	-- lua
	lspconfig["lua_ls"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	})
end

return {
	"neovim/nvim-lspconfig",
	lazy = false,
	config = config,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
}
