vim.g.netrw_liststyle = 0
vim.g.netrw_winsize = 25
vim.g.netrw_localcopydircmd = "cp -r"

function ToggleNetRWWindow()
  if vim.bo.filetype == "netrw" then
    vim.api.nvim_command("Rex")
    if vim.bo.filetype == "netrw" then
      vim.api.nvim_command("bdel")
    end
  else
    local current_bufpath = vim.fn.expand("%:p")
    local split = {}
    for w in string.gmatch(current_bufpath, "[^/]+") do
      table.insert(split, w)
    end
    local bufname = split[#split]

    vim.api.nvim_command("Ex")

    vim.defer_fn(function()
      local win_id = vim.api.nvim_get_current_win()

      if bufname == "" or bufname == nil then
        vim.api.nvim_win_set_cursor(win_id, { 8, 0 })
        return
      end

      local netrw_buf = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(netrw_buf, 0, -1, false)
      for i, line in ipairs(lines) do
        if line:gsub("[*@/=|>~]$", ""):lower() == bufname:lower() then
          if not pcall(vim.api.nvim_win_set_cursor, win_id, { i, 0 }) then
            vim.api.nvim_win_set_cursor(win_id, { 8, 0 })
          end
        end
      end
    end, 30)
  end
end

vim.api.nvim_command("command! ToggleNetRW lua ToggleNetRWWindow()")

-- setting keymaps in netrw
local netrw_group = vim.api.nvim_create_augroup("netrw", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = netrw_group,
  pattern = "netrw",
  callback = function()
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
