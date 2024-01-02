local map = require("util.keymapper").map

local function attach(bufnr)
	local api = require("nvim-tree.api")

	local opts = {
		buffer = bufnr,
		noremap = true,
		silent = true,
		nowait = true,
	}

	api.config.mappings.default_on_attach(bufnr)

	map("n", "?", api.tree.toggle_help, "NvimTree help", opts)
	map("n", "n", api.fs.create, "Create file or directory", opts)
	map("n", "N", api.fs.rename_basename, "Rename basename", opts)
end

local config = function()
	require("nvim-tree").setup({
		on_attach = attach,
		filters = {
			dotfiles = false,
		},
		view = {
			width = 32,
		},
		git = {
			enable = true,
			ignore = true,
			timeout = 499,
		},
	})
end

return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	config = config,
}
