local ok, comment = pcall(require, "Comment")

if ok then
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
end
