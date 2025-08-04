return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
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
	end,
}
