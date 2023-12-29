local config = function()
	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = "auto",
			globalstatus = true,
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "filename", "branch", "diff" },
			lualine_c = { "diagnostics" },
			lualine_x = { "" },
			lualine_y = { "encoding", "fileformat", "filetype" },
			lualine_z = { "location" },
		},
	})
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	config = config,
}
