local map = require("util.keymapper").map

local config = function()
	local conform = require("conform")

	conform.setup({
		formatters_by_ft = {
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			svelte = { "prettierd" },
			css = { "prettierd" },
			html = { "prettierd" },
			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			graphql = { "prettierd" },
			vue = { "prettierd" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			sh = { "shfmt" },
			docker = { "prettierd" },
			lua = { "stylua" },
			python = { "isort", "black" },
		},
		format_on_save = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		},
	})

	map({ "n", "v" }, "<leader>f", function()
		conform.format({
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		})
	end, "Format file or range (in visual mode)")
end

return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = config,
}
