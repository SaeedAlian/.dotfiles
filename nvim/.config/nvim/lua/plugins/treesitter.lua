return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		vim.opt.runtimepath:append("$HOME/.local/share/treesitter")

		require("nvim-treesitter.configs").setup({
			build = ":TSUpdate",
			sync_install = false,
			auto_install = true,
			indent = {
				enable = true,
			},
			autotag = {
				enable = true,
			},
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
				"typst",
			},
			parser_install_dir = "$HOME/.local/share/treesitter",
			highlight = {
				enable = true,
				disable = function(lang, buf)
					local max_filesize = 100 * 1024
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = false,
			},
			textobjects = {
				move = {
					enable = true,
					set_jumps = true,
					goto_previous_start = {
						["[f"] = { query = "@function.outer", desc = "Previous function" },
						["[c"] = { query = "@class.outer", desc = "Previous class" },
					},
					goto_next_start = {
						["]f"] = { query = "@function.outer", desc = "Next function" },
						["]c"] = { query = "@class.outer", desc = "Next class" },
					},
				},
			},
		})
	end,
}
