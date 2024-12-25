local diagnostic_signs = require("util.icons").diagnostic_signs

local mason_config = function()
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
			"lua_ls",
			"pyright",
			"bashls",
			"clangd",
			"rust_analyzer",
			"gopls",
		},
		automatic_installation = true,
	})

	mason_tool_installer.setup({
		ensure_installed = {
			"prettierd",
			"shfmt",
			"stylua",
			"isort",
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

local none_ls_config = function()
	local null_ls = require("null-ls")

	null_ls.setup({
		sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.prettierd,
			null_ls.builtins.formatting.clang_format,
			null_ls.builtins.formatting.shfmt,
			null_ls.builtins.formatting.isort,
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.gofumpt,
			null_ls.builtins.formatting.goimports_reviser,
			null_ls.builtins.formatting.golines,
		},
	})
end

local lsp_config = function()
	local lspconfig = require("lspconfig")
	local util = require("lspconfig/util")
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
		on_attach = LspOnAttach,
	})

	-- typescript
	lspconfig["tsserver"].setup({
		capabilities = capabilities,
		on_attach = LspOnAttach,
	})

	-- css
	lspconfig["cssls"].setup({
		capabilities = capabilities,
		on_attach = LspOnAttach,
	})

	-- tailwindcss
	lspconfig["tailwindcss"].setup({
		capabilities = capabilities,
		on_attach = LspOnAttach,
	})

	-- python
	lspconfig["pyright"].setup({
		capabilities = capabilities,
		on_attach = LspOnAttach,
	})

	-- bash
	lspconfig["bashls"].setup({
		capabilities = capabilities,
		on_attach = LspOnAttach,
	})

	-- rust
	lspconfig["rust_analyzer"].setup({
		capabilities = capabilities,
		on_attach = LspOnAttach,
	})

	-- c\c++
	lspconfig["clangd"].setup({
		capabilities = capabilities,
		on_attach = LspOnAttach,
		filetypes = { "cpp", "c", "h", "hpp", "cc" },
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
		},
	})

	-- lua
	lspconfig["lua_ls"].setup({
		capabilities = capabilities,
		on_attach = LspOnAttach,
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	})

	lspconfig["gopls"].setup({
		capabilities = capabilities,
		on_attach = LspOnAttach,
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		root_dir = util.root_pattern("go.work", "go.mod", ".git"),
		settings = {
			gopls = {
				completeUnimported = true,
				usePlaceholders = true,
				analyses = {
					unusedparams = true,
				},
			},
		},
	})
end

local cmp_config = function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	vim.opt.completeopt = "menu,menuone,noselect"

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		experimental = {
			ghost_text = false,
		},
		window = {
			completion = {
				max_width = 300,
				max_height = 500,
				border = "rounded",
			},
			documentation = {
				max_width = 300,
				max_height = 500,
				border = "rounded",
			},
		},
		mapping = cmp.mapping.preset.insert({
			["<C-k>"] = cmp.mapping.select_prev_item(),
			["<C-j>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-u>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
		}),
		sources = {
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "nvim_lua" },
			{ name = "buffer" },
			{ name = "path" },
			{ name = "render-markdown" },
		},
		formatting = {
			fields = { "menu", "abbr", "kind" },
			format = function(entry, item)
				local menu_icon = {
					nvim_lsp = "",
					luasnip = "",
					buffer = "",
					path = "",
				}

				item.menu = menu_icon[entry.source.name]

				return item
			end,
		},
	})
end

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = mason_config,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
	},
	{
		"nvimtools/none-ls.nvim",
		config = none_ls_config,
		lazy = false,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = lsp_config,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = cmp_config,
		event = "InsertEnter",
		dependencies = {
			{
				"hrsh7th/cmp-buffer",
				event = "InsertEnter",
			},
			{
				"hrsh7th/cmp-path",
				event = "InsertEnter",
			},
			{
				"hrsh7th/cmp-nvim-lsp",
				config = true,
				event = "InsertEnter",
			},
			{
				"hrsh7th/cmp-nvim-lua",
			},
			{
				"saadparwaiz1/cmp_luasnip",
				event = "InsertEnter",
			},
			{
				"L3MON4D3/LuaSnip",
				event = "InsertEnter",
				dependencies = {
					"rafamadriz/friendly-snippets",
				},
			},
		},
	},
}
