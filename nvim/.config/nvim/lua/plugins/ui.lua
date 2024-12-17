local theme_config = function()
  local opt = {
    style = "warmer",
    transparent = true,
    term_colors = true,
    code_style = {
      comments = "italic",
    },
    lualine = {
      transparent = true,
    },
    diagnostics = {
      darker = true,
      undercurl = true,
      background = true,
    },
  }

  require("onedark").setup(opt)
  vim.cmd.colorscheme("onedark")
end

local lualine_config = function()
  require("lualine").setup({
    options = {
      icons_enabled = true,
      theme = "auto",
      globalstatus = true,
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "filename", "branch", "diff" },
      lualine_c = { "diagnostics" },
      lualine_x = { "" },
      lualine_y = { "encoding", "fileformat", "filetype" },
      lualine_z = { "location" },
    },
  })
end

local gitsigns_config = function()
  require("gitsigns").setup()
end

return {
  {
    "navarasu/onedark.nvim",
    name = "onedark",
    priority = 1000,
    lazy = false,
    config = theme_config,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = lualine_config,
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = gitsigns_config,
  },
}
