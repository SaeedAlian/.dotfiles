local theme_colors = require("core.colors").theme_colors

local ok, theme = pcall(require, "onedark")

if ok then
	theme.setup({
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
			bg0 = theme_colors.bg0,
			bg1 = theme_colors.bg1,
			bg2 = theme_colors.bg2,
			bg3 = theme_colors.bg3,

			fg = theme_colors.fg,
			fg_dark = theme_colors.fg_dark,
			fg_light = theme_colors.fg_light,

			red = theme_colors.red,
			orange = theme_colors.orange,
			yellow = theme_colors.yellow,
			green = theme_colors.green,
			cyan = theme_colors.cyan,
			blue = theme_colors.blue,
			purple = theme_colors.purple,
		},
	})

	vim.cmd.colorscheme("onedark")
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
	vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
end
