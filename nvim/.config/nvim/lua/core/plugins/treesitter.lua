local ok, treesitter = pcall(require, "nvim-treesitter")
local ok_txtobjs, treesitter_txtobjs = pcall(require, "nvim-treesitter-textobjects")

if ok then
	vim.opt.runtimepath:append("$HOME/.local/share/treesitter")

	treesitter.setup({
		build = ":TSUpdate",
		sync_install = false,
		auto_install = false,
		parser_install_dir = "$HOME/.local/share/treesitter",
		install_dir = "$HOME/.local/share/treesitter",
	})

	treesitter.install({
		"c",
		"cpp",
		"cmake",
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
	})
end

if ok_txtobjs then
	treesitter_txtobjs.setup({
		move = { set_jumps = true },
	})
end
