local ok, mason = pcall(require, "mason")
local ok_lspconf, mason_lspconfig = pcall(require, "mason-lspconfig")
local ok_installer, mason_tool_installer = pcall(require, "mason-tool-installer")

if ok then
	mason.setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})
end

if ok_lspconf then
	mason_lspconfig.setup({
		ensure_installed = {
			"html",
			"cssls",
			"ts_ls",
			"tailwindcss",
			"lua_ls",
			"pyright",
			"bashls",
			"clangd",
			"rust_analyzer",
			"gopls",
		},
		automatic_installation = true,
	})
end

if ok_installer then
	mason_tool_installer.setup({
		ensure_installed = {
			"prettierd",
			"shfmt",
			"stylua",
			"clang-format",
			"blackd-client",
			"black",
			"golines",
			"gofumpt",
			"goimports-reviser",
		},
		automatic_installation = true,
	})
end
