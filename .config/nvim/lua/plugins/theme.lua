local opt = {
	style = "dark",
	transparent = true,
	term_colors = true,
	ending_tildes = false,
	cmp_itemkind_reverse = false,
	code_style = {
		comments = "italic",
		keywords = "none",
		functions = "none",
		strings = "none",
		variables = "none",
	},
	lualine = {
		transparent = true,
	},
	colors = {},
	highlights = {},
	diagnostics = {
		darker = true,
		undercurl = true,
		background = false,
	},
}

return {
	"navarasu/onedark.nvim",
	name = "onedark",
	priority = 1000,
	lazy = false,
	config = function()
		require("onedark").setup(opt)
		vim.cmd.colorscheme("onedark")
	end,
}
