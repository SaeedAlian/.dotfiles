local config = function()
	local mason = require("mason")
	local mason_lspconfig = require("mason-lspconfig")
	local mason_tool_installer = require("mason-tool-installer")

	mason.setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	mason_lspconfig.setup({
		ensure_installed = {
			"html",
			"cssls",
			"tsserver",
			"tailwindcss",
			"svelte",
			"lua_ls",
			"prismals",
			"pyright",
			"bashls",
			"clangd",
			"rust_analyzer",
		},
		automatic_installation = true,
	})

	mason_tool_installer.setup({
		ensure_installed = {
			"prettierd",
			"shfmt",
			"stylua",
			"luacheck",
			"shellcheck",
			"isort",
			"black",
			"eslint_d",
			"clang-format",
			"rustfmt",
		},
	})
end

return {
	"williamboman/mason.nvim",
	lazy = false,
	config = config,
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
}
