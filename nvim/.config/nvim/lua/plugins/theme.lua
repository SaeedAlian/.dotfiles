return {
	"navarasu/onedark.nvim",
	name = "onedark",
	priority = 1000,
	lazy = false,
	config = function()
		local opt = {
			style = "dark",
			transparent = true,
			term_colors = true,
			code_style = {
				comments = "italic",
			},
			lualine = {
				transparent = true,
			},
			diagnostics = {
				darker = true,
				undercurl = true,
				background = true,
			},
			colors = {
				bg0 = "#14151B",
				bg1 = "#1B1B20",
				bg2 = "#20232F",
				bg3 = "#36373C",

				fg = "#CED1D9",
				fg_dark = "#BEC0CB",
				fg_light = "#D7DAE7",

				red = "#D27078",
				orange = "#D5916E",
				yellow = "#D2BA4F",
				green = "#98C379",
				cyan = "#5DA3AC",
				blue = "#7E9FE5",
				purple = "#B282C0",
			},
		}

		require("onedark").setup(opt)

		vim.cmd.colorscheme("onedark")
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
		vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
	end,
}
