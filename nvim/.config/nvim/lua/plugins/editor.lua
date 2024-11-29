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

local netrw_config = function()
	require("netrw").setup({
		icons = {
			symlink = "",
			directory = "",
			file = "",
		},
		use_devicons = true,
		mappings = {},
	})
end

local treesitter_config = function()
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
		textobjects = {
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

local telescope_config = function()
	local telescope = require("telescope")
	local actions = require("telescope.actions")

	telescope.setup({
		defaults = {
			file_ignore_patterns = {
				".git/",
				".venv/",
				"target/",
				".cache/",
				"build/",
				"node_modules/",
				"__pycache__/",
			},
			prompt_prefix = " > ",
			color_devicons = true,
			sorting_strategy = "ascending",
			mappings = {
				n = {
					["q"] = actions.close,
					["/"] = function()
						vim.cmd("startinsert")
					end,
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
				},
			},
		},
		pickers = {
			find_files = {
				previewer = false,
				hidden = true,
			},
			live_grep = {
				previewer = false,
				hidden = true,
			},
			buffers = {
				previewer = false,
				hidden = true,
			},
		},
	})
end

return {
	{
		"prichrd/netrw.nvim",
		lazy = false,
		config = netrw_config,
	},
	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = comment_config,
	},
	{
		"tpope/vim-fugitive",
		lazy = false,
	},
	{
		"szw/vim-maximizer",
		lazy = false,
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
		},
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
			map("n", "<leader>vh", ":Telescope help_tags<CR>"),
			map("n", "<leader>pf", ":Telescope find_files<CR>"),
			map("n", "<leader>pg", ":Telescope git_files<CR>"),
			map("n", "<leader>lg", ":Telescope live_grep<CR>"),
			map("n", "<leader>pb", ":Telescope buffers<CR>"),
			map("n", "<leader>pt", function()
				local builtin = require("telescope.builtin")
				builtin.treesitter()
			end),
		},
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<C-h>", "<cmd><C-U>TmuxNavigateLeft<CR>" },
			{ "<C-j>", "<cmd><C-U>TmuxNavigateDown<CR>" },
			{ "<C-k>", "<cmd><C-U>TmuxNavigateUp<CR>" },
			{ "<C-l>", "<cmd><C-U>TmuxNavigateRight<CR>" },
			{ "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<CR>" },
		},
	},
	{
		"mbbill/undotree",
		lazy = false,
	},
}
