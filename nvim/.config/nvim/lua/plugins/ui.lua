local alpha_nvim_config = function()
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")

	-- Set header
	dashboard.section.header.val = {
		[[                                                                       ]],
		[[                                                                     ]],
		[[       ████ ██████           █████      ██                     ]],
		[[      ███████████             █████                             ]],
		[[      █████████ ███████████████████ ███   ███████████   ]],
		[[     █████████  ███    █████████████ █████ ██████████████   ]],
		[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
		[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
		[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
		[[                                                                       ]],
		[[                                                                       ]],
		[[                                                                       ]],
	}

	-- Set menu
	dashboard.section.buttons.val = {
		dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
		dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
		dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
		dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
		dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
		dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
	}

	-- Send config to alpha
	alpha.setup(dashboard.opts)

	-- Disable folding on alpha buffer
	vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
end

local theme_config = function()
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
			background = false,
		},
	}

	require("onedark").setup(opt)
	vim.cmd.colorscheme("onedark")
end

local bufferline_config = function()
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

local lualine_config = function()
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

local gitsigns_config = function()
	require("gitsigns").setup()
end

return {
	{
		"navarasu/onedark.nvim",
		name = "onedark",
		priority = 1000,
		lazy = false,
		config = theme_config,
	},
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = alpha_nvim_config,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		config = lualine_config,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		lazy = false,
		config = bufferline_config,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		config = gitsigns_config,
	},
}
