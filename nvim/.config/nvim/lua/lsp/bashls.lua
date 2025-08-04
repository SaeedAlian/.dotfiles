return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh" },
	root_markers = { ".git" },
	settings = {
		bashlde = {
			globPattern = "*@(.sh|.inc|.bash|.command)",
		},
	},
}
