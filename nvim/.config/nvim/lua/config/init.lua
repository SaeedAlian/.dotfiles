local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.loader.enable()

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("config.globals")
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.netrw")

local plugins_path = "plugins"

local opt = {
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = { "onedark" },
  },
  rtp = {
    disabled_plugins = {
      "gzip",
      "matchit",
      "matchparen",
      "tarPlugin",
      "tohtml",
      "tutor",
      "zipPlugin",
    },
  },
  change_detection = {
    notify = false,
  },
}

require("lazy").setup(plugins_path, opt)
