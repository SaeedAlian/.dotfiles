return {
  "williamboman/mason.nvim",
  lazy = false,
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "html",
        "cssls",
        "ts_ls",
        "tailwindcss",
        "lua_ls",
        "pyright",
        "bashls",
        "clangd",
        "rust_analyzer",
        "gopls",
      },
      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettierd",
        "shfmt",
        "stylua",
        "clang-format",
        "blackd-client",
        "black",
        "golines",
        "gofumpt",
        "goimports-reviser",
      },
      automatic_installation = true,
    })
  end,
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
}
