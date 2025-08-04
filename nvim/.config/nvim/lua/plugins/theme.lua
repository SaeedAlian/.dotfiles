return {
  "navarasu/onedark.nvim",
  name = "onedark",
  priority = 1000,
  lazy = false,
  config = function()
    local opt = {
      style = "dark",
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
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
  end,
}
