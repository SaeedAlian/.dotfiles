local theme_config = function()
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
end

local statusline_config = function()
  local function git_branch()
    local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    if branch ~= "" then
      return branch
    end
    return "[No Git]"
  end

  local function file_name()
    if vim.bo.filetype == "oil" or vim.bo.filetype == "netrw" then
      return "[Explorer]"
    end
    local path = vim.fn.expand("%:p")

    if path == "" then
      return "[No Name]"
    end

    local parts = vim.split(path, "/")
    return parts[#parts]
  end

  local function file_size()
    local size = vim.fn.getfsize(vim.fn.expand("%"))
    if size < 0 then
      return ""
    end
    if size < 1024 then
      return size .. "B "
    elseif size < 1024 * 1024 then
      return string.format("%.1fK", size / 1024)
    else
      return string.format("%.1fM", size / 1024 / 1024)
    end
  end

  local function mode_icon()
    local mode = vim.fn.mode()
    local modes = {
      n = "NORMAL",
      i = "INSERT",
      v = "VISUAL",
      V = "V-LINE",
      ["\22"] = "V-BLOCK",
      c = "COMMAND",
      s = "SELECT",
      S = "S-LINE",
      ["\19"] = "S-BLOCK",
      R = "REPLACE",
      r = "REPLACE",
      ["!"] = "SHELL",
      t = "TERMINAL",
    }
    return modes[mode] or ("  " .. mode:upper())
  end

  local function file_type()
    local ft = vim.bo.filetype
    return ft
  end

  _G.mode_icon = mode_icon
  _G.git_branch = git_branch
  _G.file_type = file_type
  _G.file_size = file_size
  _G.file_name = file_name

  vim.cmd([[
    highlight StatusLineBold gui=bold cterm=bold
  ]])

  local function setup_dynamic_statusline()
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
      callback = function()
        vim.opt_local.statusline = table.concat({
          " ",
          "%#StatusLineBold#",
          "%{v:lua.mode_icon()}",
          "%#StatusLine#",
          " │ ",
          "%{v:lua.file_name()}%m",
          " │ ",
          "%{v:lua.git_branch()}",
          " │ ",
          "%{v:lua.file_type()}",
          " │ ",
          "%{v:lua.file_size()}",
          "%=",
          "%l:%c ",
        })
      end,
    })
    vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
      callback = function()
        vim.opt_local.statusline = " %{v:lua.file_name()} │ %{v:lua.file_type()} | %=  %l:%c "
      end,
    })
  end

  setup_dynamic_statusline()
end

local gitsigns_config = function()
  require("gitsigns").setup()
end

statusline_config()

return {
  {
    "navarasu/onedark.nvim",
    name = "onedark",
    priority = 1000,
    lazy = false,
    config = theme_config,
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = gitsigns_config,
  },
}
