local theme_colors = require("core.colors").theme_colors

vim.opt.runtimepath:append("$HOME/.local/share/nvim")

vim.pack.add({
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/szw/vim-maximizer",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/navarasu/onedark.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/mbbill/undotree",

	{ src = "https://github.com/saghen/blink.cmp", version = "v1" },
	{ src = "https://github.com/prichrd/netrw.nvim", version = "90501c6" },
})

local cmp = require("blink.cmp")
local comment = require("Comment")
local conform = require("conform")
local gitsigns = require("gitsigns")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")
local netrw_module = require("netrw")
local telescope = require("telescope")
local telescope_actions = require("telescope.actions")
local theme = require("onedark")
local treesitter = require("nvim-treesitter")
local treesitter_txtobjs = require("nvim-treesitter-textobjects")

-- blink cmp
cmp.setup({
	keymap = {
		preset = "default",

		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide" },
		["<CR>"] = { "accept", "fallback" },

		["<C-k>"] = { "select_prev", "fallback_to_mappings" },
		["<C-j>"] = { "select_next", "fallback_to_mappings" },

		["<C-p>"] = { "scroll_documentation_up", "fallback" },
		["<C-n>"] = { "scroll_documentation_down", "fallback" },

		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },

		["<C-l>"] = { "show_documentation", "hide_documentation", "fallback" },
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = false },
		list = {
			max_items = 100,
			selection = {
				preselect = false,
				auto_insert = true,
			},
		},
		accept = {
			auto_brackets = {
				enabled = false,
			},
		},
	},
	sources = {
		default = { "lsp", "path", "buffer", "snippets" },
	},
	fuzzy = { implementation = "rust" },
})

-- comment
comment.setup({
	toggler = {
		line = "\\",
		block = "<leader>\\",
	},
	opleader = {
		line = "\\",
		block = "<leader>\\",
	},
})

-- conform
conform.setup({
	formatters_by_ft = {
		go = { "goimports", "gofmt" },
		lua = { "stylua" },

		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		json = { "prettierd" },
		jsonc = { "prettierd" },
		yaml = { "prettierd" },
		markdown = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		scss = { "prettierd" },

		python = { "isort", "black" },

		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },

		rust = { "rustfmt" },

		c = { "clang-format" },
		cpp = { "clang-format" },
		h = { "clang-format" },
		hpp = { "clang-format" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
})

-- gitsigns
gitsigns.setup()

-- mason
mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

mason_lspconfig.setup({
	ensure_installed = {
		"html",
		"cssls",
		"ts_ls",
		"tailwindcss",
		"lua_ls",
		"pyright",
		"bashls",
		"clangd",
		"rust_analyzer",
		"gopls",
	},
	automatic_installation = true,
})

mason_tool_installer.setup({
	ensure_installed = {
		"prettierd",
		"shfmt",
		"stylua",
		"clang-format",
		"blackd-client",
		"black",
		"golines",
		"gofumpt",
		"goimports-reviser",
	},
	automatic_installation = true,
})

-- netrw
netrw_module.setup({
	icons = {
		symlink = "",
		directory = "",
		file = "",
	},
	use_devicons = true,
})

-- telescope
telescope.setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--follow",
			"--hidden",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--glob=!**/.git/*",
			"--glob=!**/.idea/*",
			"--glob=!**/.vscode/*",
			"--glob=!**/build/*",
			"--glob=!**/dist/*",
			"--glob=!**/yarn.lock",
			"--glob=!**/package-lock.json",
		},
		file_ignore_patterns = {
			".git/",
			".venv/",
			"target/",
			".cache/",
			"build/",
			"node_modules/",
			"__pycache__/",
		},
		prompt_prefix = " > ",
		color_devicons = true,
		sorting_strategy = "ascending",
		mappings = {
			n = {
				["q"] = telescope_actions.close,
				["/"] = function()
					vim.cmd("startinsert")
				end,
			},
			i = {
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous",
				["<C-w>"] = function()
					vim.cmd("normal vbd")
				end,
				["<C-i>"] = function()
					vim.cmd("stopinsert")
				end,
			},
		},
	},
	pickers = {
		find_files = {
			previewer = false,
			hidden = true,
			no_ignore = true,
			no_ignore_parent = true,
			theme = "dropdown",
		},
		live_grep = {
			previewer = true,
			hidden = true,
			theme = "dropdown",
		},
	},
})

-- theme
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

-- treesitter
vim.opt.runtimepath:append("$HOME/.local/share/treesitter")

treesitter.setup({
	build = ":TSUpdate",
	sync_install = false,
	auto_install = false,
	ensure_installed = {
		"c",
		"cpp",
		"rust",
		"json",
		"javascript",
		"latex",
		"typescript",
		"html",
		"tsx",
		"css",
		"bash",
		"lua",
		"dockerfile",
		"gitignore",
		"sql",
		"go",
		"markdown_inline",
		"python",
		"typst",
	},
	parser_install_dir = "$HOME/.local/share/treesitter",
})

treesitter_txtobjs.setup({
	move = { set_jumps = true },
})
