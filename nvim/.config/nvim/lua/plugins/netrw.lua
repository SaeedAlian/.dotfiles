return {
	"prichrd/netrw.nvim",
	lazy = false,
	config = function()
		require("netrw").setup({
			icons = {
				symlink = "",
				directory = "",
				file = "",
			},
			use_devicons = true,
		})
	end,
}
