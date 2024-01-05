local map = require("util.keymapper").map
local on_attach = require("util.lsp").on_attach
local diagnostic_signs = require("util.icons").diagnostic_signs

local mason_config = function()
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
      "tsserver",
      "tailwindcss",
      "svelte",
      "lua_ls",
      "prismals",
      "pyright",
      "bashls",
      "clangd",
      "rust_analyzer",
    },
    automatic_installation = true,
  })

  mason_tool_installer.setup({
    ensure_installed = {
      "prettierd",
      "shfmt",
      "stylua",
      "luacheck",
      "shellcheck",
      "isort",
      "black",
      "eslint_d",
      "clang-format",
      "rustfmt",
    },
  })
end

local none_ls_config = function()
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
    },
  })

  map("n", "<leader>f", vim.lsp.buf.format, "Format the current buffer", {})
end

local lsp_config = function()
  require("neoconf").setup({})

  local lspconfig = require("lspconfig")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = cmp_nvim_lsp.default_capabilities()

  -- set diagnostics icons
  for type, icon in pairs(diagnostic_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  -- html
  lspconfig["html"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- typescript
  lspconfig["tsserver"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- css
  lspconfig["cssls"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- tailwindcss
  lspconfig["tailwindcss"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- python
  lspconfig["pyright"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- bash
  lspconfig["bashls"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- rust
  lspconfig["rust_analyzer"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    server = {
      path = "/home/cosmicentropy/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer",
    },
  })

  -- c\c++
  lspconfig["clangd"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "cpp", "c", "h", "hpp", "cc" },
    cmd = {
      "clangd",
      "--offset-encoding=utf-16",
    },
  })

  -- lua
  lspconfig["lua_ls"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
      },
    },
  })
end

local cmp_config = function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  vim.opt.completeopt = "menu,menuone,noselect"

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp", keyword_length = 1 },
      { name = "luasnip",  keyword_length = 2 },
    }, {
      { name = "buffer", keyword_length = 3 },
    }),
    formatting = {
      fields = { "menu", "abbr", "kind" },
      format = function(entry, item)
        local menu_icon = {
          nvim_lsp = "λ",
          luasnip = "⋗",
          buffer = "Ω",
          path = "🖫",
        }

        item.menu = menu_icon[entry.source.name]

        return item
      end,
    },
  })
end

local luasnip_config = function()
  require("luasnip.loaders.from_vscode").lazy_load()
end

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = mason_config,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
  },
  {
    "nvimtools/none-ls.nvim",
    config = none_ls_config,
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = lsp_config,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    config = cmp_config,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = false,
    config = true,
  },
  {
    "L3MON4D3/LuaSnip",
    lazy = false,
    config = luasnip_config,
    dependencies = {
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
  },
}
