return {
	"saghen/blink.cmp",
	lazy = false,
	version = "1.*",
	opts = {
		keymap = {
			preset = "default",

			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide" },
			["<CR>"] = { "accept", "fallback" },

			["<C-k>"] = { "select_prev", "fallback_to_mappings" },
			["<C-j>"] = { "select_next", "fallback_to_mappings" },

			["<C-p>"] = { "scroll_documentation_up", "fallback" },
			["<C-n>"] = { "scroll_documentation_down", "fallback" },

			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },

			["<C-l>"] = { "show_documentation", "hide_documentation", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			documentation = { auto_show = false },
			list = {
				max_items = 100,
				selection = {
					preselect = false,
					auto_insert = true,
				},
			},
			accept = {
				auto_brackets = {
					enabled = false,
				},
			},
		},
		sources = {
			default = { "lsp", "path", "buffer", "snippets" },
		},
		fuzzy = { implementation = "rust" },
	},
	opts_extend = { "sources.default" },
}
