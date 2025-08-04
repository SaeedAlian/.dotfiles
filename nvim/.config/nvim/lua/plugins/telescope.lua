return {
	"nvim-telescope/telescope.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
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
					theme = "ivy",
				},
				live_grep = {
					previewer = false,
					hidden = true,
					theme = "ivy",
				},
			},
		})
	end,
}
