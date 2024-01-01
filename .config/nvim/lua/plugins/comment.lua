local config = function()
	require("Comment").setup({
		toggler = {
			line = "<C-_>",
			block = "<leader><C-_>",
		},
		opleader = {
			line = "<C-_>",
			block = "<leader><C-_>",
		},
	})
end

return {
	"numToStr/Comment.nvim",
	config = config,
	lazy = false,
}
