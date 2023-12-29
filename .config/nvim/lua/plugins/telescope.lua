local config = function()
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

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = config,
	keys = {
		vim.keymap.set("n", "<leader>vh", ":Telescope help_tags<CR>"),
		vim.keymap.set("n", "<leader>pf", ":Telescope find_files<CR>"),
		vim.keymap.set("n", "<leader>pg", ":Telescope git_files<CR>"),
		vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>"),
		vim.keymap.set("n", "<leader>pb", ":Telescope buffers<CR>"),
	},
}
