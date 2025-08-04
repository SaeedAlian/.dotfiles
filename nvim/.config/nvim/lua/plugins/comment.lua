return {
	"numToStr/Comment.nvim",
	lazy = false,
	config = function()
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
	end,
}
