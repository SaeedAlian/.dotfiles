vim.opt.runtimepath:append("$HOME/.local/share/treesitter")

local config = function()
	require("nvim-treesitter.install").compilers = { "gpp", "gcc", "clang", "mingw" }

	require("nvim-treesitter.configs").setup({
		build = ":TSUpdate",
		indent = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		ensure_installed = {
			"c",
			"cpp",
			"cmake",
			"rust",
			"markdown",
			"markdown_inline",
			"json",
			"javascript",
			"typescript",
			"html",
			"tsx",
			"css",
			"bash",
			"lua",
			"dockerfile",
			"gitignore",
			"sql",
			"regex",
		},
		auto_install = true,
		parser_install_dir = "$HOME/.local/share/treesitter",
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<leader>si",
				node_incremental = "]]",
				scope_incremental = false,
				node_decremental = "[[",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = { query = "@function.outer", desc = "around a function" },
					["if"] = { query = "@function.inner", desc = "inner part of a function" },
					["ac"] = { query = "@class.outer", desc = "around a class" },
					["ic"] = { query = "@class.inner", desc = "inner part of a class" },
					["ai"] = { query = "@conditional.outer", desc = "around an if statement" },
					["ii"] = { query = "@conditional.inner", desc = "inner part of an if statement" },
					["al"] = { query = "@loop.outer", desc = "around a loop" },
					["il"] = { query = "@loop.inner", desc = "inner part of a loop" },
				},
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@parameter.inner"] = "v", -- charwise
					["@function.outer"] = "v", -- charwise
					["@conditional.outer"] = "V", -- linewise
					["@loop.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
				include_surrounding_whitespace = false,
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_previous_start = {
					["[f"] = { query = "@function.outer", desc = "Previous function" },
					["[c"] = { query = "@class.outer", desc = "Previous class" },
				},
				goto_next_start = {
					["]f"] = { query = "@function.outer", desc = "Next function" },
					["]c"] = { query = "@class.outer", desc = "Next class" },
				},
			},
		},
	})
end

local context_conf = function()
	require("treesitter-context").setup({
		enable = true,
		max_lines = 4,
		line_numbers = true,
	})
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = config,
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/playground",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = context_conf,
	},
}
