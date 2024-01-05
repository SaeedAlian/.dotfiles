vim.opt.runtimepath:append("$HOME/.local/share/treesitter")

local map = require("util.keymapper").map

local comment_config = function()
	require("Comment").setup({
		toggler = {
			line = "\\",
			block = "<leader>\\",
		},
		opleader = {
			line = "\\",
			block = "<leader>\\",
		},
	})
end

local treesitter_config = function()
	require("nvim-treesitter.configs").setup({
		-- build = ":TSUpdate",
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
			"rust",
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

local treesitter_context_conf = function()
	require("treesitter-context").setup({
		enable = true,
		max_lines = 4,
		line_numbers = true,
	})
end

local telescope_config = function()
	local telescope = require("telescope")
	local actions = require("telescope.actions")

	telescope.setup({
		defaults = {
			file_ignore_patterns = {
				".git/",
				".cache",
				"build/",
				"node_modules/",
				"%.o",
				"%.a",
				"%.out",
			},
			wrap_results = true,
			layout_strategy = "vertical",
			layout_config = { prompt_position = "top" },
			sorting_strategy = "ascending",
			winblend = 0,
			mappings = {
				n = {
					["q"] = actions.close,
					["/"] = function()
						vim.cmd("startinsert")
					end,
					["<S-Tab>"] = actions.preview_scrolling_up,
					["<Tab>"] = actions.preview_scrolling_down,
				},
				i = {
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
					["<C-w>"] = function()
						vim.cmd("normal vbd")
					end,
					["<C-i>"] = function()
						vim.cmd("stopinsert")
					end,
					["<S-Tab>"] = actions.preview_scrolling_up,
					["<Tab>"] = actions.preview_scrolling_down,
				},
			},
		},
		pickers = {
			find_files = {
				theme = "dropdown",
				previewer = true,
				hidden = true,
			},
			live_grep = {
				theme = "dropdown",
				previewer = true,
				hidden = true,
			},
			buffers = {
				theme = "dropdown",
				previewer = true,
				hidden = true,
			},
		},
	})
end

local function nvim_tree_attach(bufnr)
	local api = require("nvim-tree.api")

	local opts = {
		buffer = bufnr,
		noremap = true,
		silent = true,
		nowait = true,
	}

	api.config.mappings.default_on_attach(bufnr)

	map("n", "?", api.tree.toggle_help, "NvimTree help", opts)
	map("n", "n", api.fs.create, "Create file or directory", opts)
	map("n", "R", api.fs.rename_basename, "Rename basename", opts)
end

local nvim_tree_config = function()
	require("nvim-tree").setup({
		on_attach = nvim_tree_attach,
		filters = {
			dotfiles = false,
		},
		view = {
			width = 25,
			number = true,
			relativenumber = true,
		},
		git = {
			enable = true,
			ignore = true,
			timeout = 500,
		},
		diagnostics = {
			enable = true,
		},
		actions = {
			open_file = {
				quit_on_open = true,
			},
		},
		update_focused_file = {
			enable = true,
		},
	})
end

return {
	{
		"numToStr/Comment.nvim",
		config = comment_config,
		lazy = false,
	},
	{
		lazy = false,
		"tpope/vim-fugitive",
	},
	{
		"szw/vim-maximizer",
		keys = {
			{ "sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = treesitter_config,
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
		config = treesitter_context_conf,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = telescope_config,
		keys = {
			vim.keymap.set("n", "<leader>vh", ":Telescope help_tags<CR>"),
			vim.keymap.set("n", "<leader>pf", ":Telescope find_files<CR>"),
			vim.keymap.set("n", "<leader>pg", ":Telescope git_files<CR>"),
			vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>"),
			vim.keymap.set("n", "<leader>pb", ":Telescope buffers<CR>"),
		},
	},
	{
		"windwp/nvim-ts-autotag",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"moll/vim-bbye",
		lazy = false,
	},
	{
		"mbbill/undotree",
		lazy = false,
	},
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		config = nvim_tree_config,
	},
}
