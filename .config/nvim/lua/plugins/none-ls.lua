local map = require("util.keymapper").map

local config = function()
	local null_ls = require("null-ls")

	null_ls.setup({
		sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.prettierd,
			null_ls.builtins.formatting.clang_format,
			null_ls.builtins.formatting.shfmt,
			null_ls.builtins.formatting.rustfmt,
			null_ls.builtins.formatting.isort,
			null_ls.builtins.formatting.black,
			null_ls.builtins.diagnostics.eslint_d,
			null_ls.builtins.diagnostics.luacheck,
			null_ls.builtins.diagnostics.shellcheck,
		},
	})

	map("n", "<leader>f", vim.lsp.buf.format, "Format the current buffer", {})
end

return {
	"nvimtools/none-ls.nvim",
	config = config,
}
