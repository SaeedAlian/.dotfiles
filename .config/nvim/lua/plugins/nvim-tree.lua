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

return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	config = function()
		require("nvim-tree").setup({
			on_attach = attach,
			filters = {
				dotfiles = false,
			},
			view = {
				adaptive_size = true,
			},
			git = {
				enable = true,
				ignore = true,
				timeout = 500,
			},
		})
	end,
}
