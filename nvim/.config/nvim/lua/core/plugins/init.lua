vim.opt.runtimepath:append("$HOME/.local/share/nvim")

local packages = {
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/szw/vim-maximizer",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/navarasu/onedark.nvim",
	"https://github.com/mbbill/undotree",

	{ src = "https://github.com/prichrd/netrw.nvim", version = "90501c6" },
}

local extra_packages = {
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

	{ src = "https://github.com/saghen/blink.cmp", version = "v1" },
}

if not _G.USE_MINIMAL then
	for _, pkg in ipairs(extra_packages) do
		table.insert(packages, pkg)
	end
end

vim.pack.add(packages)

require("core.plugins.theme")
require("core.plugins.netrw")
require("core.plugins.telescope")
require("core.plugins.gitsigns")
require("core.plugins.comment")
require("core.plugins.treesitter")
require("core.plugins.mason")
require("core.plugins.blink")
require("core.plugins.conform")
