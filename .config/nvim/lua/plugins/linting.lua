local map = require("util.keymapper").map

local config = function()
	local lint = require("lint")

	lint.linters_by_ft = {
		javascript = { "eslint" },
		typescript = { "eslint" },
		javascriptreact = { "eslint" },
		typescriptreact = { "eslint" },
		svelte = { "eslint" },
		python = { "flake8" },
		json = { "eslint" },
		vue = { "eslint" },
		sh = { "shellcheck" },
		docker = { "hadolint" },
		lua = { "luacheck" },
	}

	local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
		group = lint_augroup,
		callback = function()
			lint.try_lint()
		end,
	})

	map("n", "<leader>l", function()
		lint.try_lint()
	end, "Trigger linting for current file")
end

return {
	"mfussenegger/nvim-lint",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = config,
}
