local map = require("util.keymapper").map

local g = vim.g

-- removes netrw window
g.netrw_browse_split = 0
g.netrw_banner = 0
g.netrw_winsize = 25

-- removes .. and . in the top of netrw buffer
g.netrw_list_hide = "^\\.\\.\\/$"

function ToggleNetRWWindow()
  if vim.bo.filetype == "netrw" then
    vim.api.nvim_command("Rex")
    if vim.bo.filetype == "netrw" then
      vim.api.nvim_command("bdel")
    end
  else
    vim.api.nvim_command("Ex")
  end
end

vim.api.nvim_command("command! ToggleNetRW lua ToggleNetRWWindow()")

-- launch netrw
map("n", "<leader>pd", ":ToggleNetRW<CR>", "Toggle NetRW")

-- setting keymaps in netrw
vim.api.nvim_create_augroup("netrw", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "netrw",
  pattern = "netrw",
  callback = function()
    vim.api.nvim_command("setlocal buftype=nofile")
    vim.api.nvim_command("setlocal bufhidden=wipe")
    vim.keymap.set("n", "<esc>", "<CMD>ToggleNetRW<CR>", { noremap = true, silent = true, buffer = true })
    vim.keymap.set("n", "s", "<Nop>", { noremap = true, silent = true, buffer = true })
    vim.keymap.set("n", "r", "<Nop>", { noremap = true, silent = true, buffer = true })
    vim.keymap.set(
      "n",
      "P",
      "<CMD>Ex " .. vim.fn.getcwd() .. "<CR>",
      { remap = true, silent = true, buffer = true }
    )
  end,
})
