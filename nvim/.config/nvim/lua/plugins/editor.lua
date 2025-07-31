vim.opt.runtimepath:append("$HOME/.local/share/treesitter")

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

local oil_config = function()
	require("oil").setup({
		default_file_explorer = true,
		columns = {
			"icon",
		},
		buf_options = {
			buflisted = false,
			bufhidden = "hide",
		},
		win_options = {
			wrap = false,
			signcolumn = "yes",
			cursorcolumn = false,
			foldcolumn = "0",
			spell = false,
			list = false,
			conceallevel = 3,
			concealcursor = "nvic",
		},
		skip_confirm_for_simple_edits = false,
		prompt_save_on_select_new_entry = true,
		lsp_file_methods = {
			enabled = true,
			timeout_ms = 5000,
			autosave_changes = false,
		},
		constrain_cursor = "editable",
		watch_for_changes = true,
		keymaps = {
			["<leader>?"] = { "actions.show_help", mode = "n" },
			["<CR>"] = "actions.select",
			["<C-p>"] = "actions.preview",
			["<C-c>"] = { "actions.close", mode = "n" },
			["<C-;>"] = "actions.refresh",
			["-"] = { "actions.parent", mode = "n" },
			["_"] = { "actions.open_cwd", mode = "n" },
			["`"] = { "actions.cd", mode = "n" },
			["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
			["."] = { "actions.toggle_hidden", mode = "n" },
		},
		use_default_keymaps = false,
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name, _)
				return name == ".."
			end,
			natural_order = "fast",
			case_insensitive = false,
			sort = {
				{ "type", "asc" },
				{ "name", "asc" },
			},
		},
	})

	vim.api.nvim_create_user_command("OilToggle", function()
		local current_buf = vim.api.nvim_get_current_buf()
		local current_filetype = vim.api.nvim_buf_get_option(current_buf, "filetype")

		local bufs = vim.api.nvim_list_bufs()

		if current_filetype == "oil" then
			if #bufs > 1 then
				vim.cmd("b#")
			end
		else
			vim.cmd("Oil")
		end
	end, { nargs = 0 })
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
			"latex",
			"typescript",
			"html",
			"tsx",
			"css",
			"bash",
			"lua",
			"dockerfile",
			"gitignore",
			"sql",
			"markdown_inline",
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
				no_ignore = true,
				no_ignore_parent = true,
			},
			git_files = {
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
			diagnostics = {
				previewer = false,
				hidden = true,
			},
		},
	})
end

return {
	{
		"stevearc/oil.nvim",
		lazy = false,
		config = oil_config,
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
		tag = "0.1.7",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = telescope_config,
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
	},
	{
		"mbbill/undotree",
		lazy = false,
	},
}
