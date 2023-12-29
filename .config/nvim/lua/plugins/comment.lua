local config = function()
	require("Comment").setup({
		toggler = {
			line = "<C-/>",
		},
		opleader = {
			line = "<C-/>",
		},
	})
end

return {
	"numToStr/Comment.nvim",
	config = config,
	lazy = false,
}
