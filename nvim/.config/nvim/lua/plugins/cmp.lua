local config = function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	vim.opt.completeopt = "menu,menuone,noselect"

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-k>"] = cmp.mapping.select_prev_item(),
			["<C-j>"] = cmp.mapping.select_next_item(),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp", keyword_length = 1 },
			{ name = "luasnip", keyword_length = 2 },
		}, {
			{ name = "buffer", keyword_length = 3 },
		}),
		formatting = {
			fields = { "menu", "abbr", "kind" },
			format = function(entry, item)
				local menu_icon = {
					nvim_lsp = "λ",
					luasnip = "⋗",
					buffer = "Ω",
					path = "🖫",
				}

				item.menu = menu_icon[entry.source.name]

				return item
			end,
		},
	})
end

local luasnip_conf = function()
	require("luasnip.loaders.from_vscode").lazy_load()
end

return {
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		config = config,
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		lazy = false,
		config = true,
	},
	{
		"L3MON4D3/LuaSnip",
		lazy = false,
		config = luasnip_conf,
		dependencies = {
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
		},
	},
}
