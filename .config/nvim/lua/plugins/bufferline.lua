local config = function()
	require("bufferline").setup({
		options = {
			mode = "buffers",
			diagnostics = false,
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					highlight = "Directory",
					text_align = "left",
				},
			},
		},
	})
end

return {
	"akinsho/bufferline.nvim",
	version = "*",
	lazy = false,
	config = config,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
