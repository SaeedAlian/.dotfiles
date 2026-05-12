local status_line_colors = {
	normal = {
		bg = "#7190D3",
		fg = "#14151B",
	},

	insert = {
		bg = "#98C379",
		fg = "#14151B",
	},

	visual = {
		bg = "#DD9CF0",
		fg = "#14151B",
	},

	visual_line = {
		bg = "#8800B0",
		fg = "#CED1D9",
	},

	visual_block = {
		bg = "#C100F9",
		fg = "#14151B",
	},

	command = {
		bg = "#D5916E",
		fg = "#14151B",
	},

	replace = {
		bg = "#D27078",
		fg = "#14151B",
	},

	terminal = {
		bg = "#CED1D9",
		fg = "#14151B",
	},

	dim = {
		bg = "#212329",
		fg = "#82838C",
	},
}

local theme_colors = {
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
}

return {
	status_line_colors = status_line_colors,
	theme_colors = theme_colors,
}
