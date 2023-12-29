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
			"tsserver",
			"html",
			"cssls",
			"tailwindcss",
			"svelte",
			"lua_ls",
			"graphql",
			"emmet_ls",
			"prismals",
			"pyright",
			"clangd",
			"bashls",
			"dockerls",
			"jsonls",
			"cmake",
			"html",
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
			"hadolint",
			"shellcheck",
			"isort",
			"black",
			"flake8",
			"eslint",
			"clang-format",
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
