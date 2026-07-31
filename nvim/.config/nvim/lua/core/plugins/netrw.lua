local ok, netrw_module = pcall(require, "netrw")

if ok then
	netrw_module.setup({
		icons = {
			symlink = "",
			directory = "",
			file = "",
		},
		use_devicons = true,
	})
end
