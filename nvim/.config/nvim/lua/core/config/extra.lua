local map = require("utils.keymapper").map

-- -- autocmds -- --

-- autoformat on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		if vim.g.autoformat then
			require("conform").format({ bufnr = args.buf, timeout_ms = 5000 })
		end
	end,
})

-- treesitter start
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- -- keymaps -- --

-- toggle autoformat on save
map("n", "<leader>af", function()
	if vim.g.autoformat then
		vim.g.autoformat = false
		print("Autoformat turned off")
	else
		vim.g.autoformat = true
		print("Autoformat turned on")
	end
end, "Toggle auto format")

-- format buffer
map({ "n", "v" }, "<leader>f", function()
	if vim.g.autoformat then
		require("conform").format({ timeout_ms = 10000, async = true })
	end
end, "Format buffer")

-- git
map("n", "<leader>gs", ":Git<CR>", "Git status")
map("n", "<leader>gc", ":Git commit<CR>", "Git commit")
map("n", "<leader>gp", ":Git push<CR>", "Git push")

-- fzf picker
map("n", "<leader>pt", function()
	local builtin = require("telescope.builtin")
	builtin.treesitter()
end, "Search through variables, functions etc. in a code buffer which has treesitter with telescope")

-- treesitter text objects
map({ "n", "x", "o" }, "]f", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end)
map({ "n", "x", "o" }, "[f", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end)
map({ "n", "x", "o" }, "]c", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
end)
map({ "n", "x", "o" }, "[c", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
end)

-- -- -- -- end config -- -- -- --
