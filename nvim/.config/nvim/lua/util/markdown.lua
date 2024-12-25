local get_current_file = function()
  local current_filename = vim.api.nvim_buf_get_name(0)

  if current_filename == "" then
    return nil
  end

  return current_filename
end

local get_filename = function(absolute_path)
  return string.gsub(absolute_path, ".*/", "")
end

local check_md_file = function(current_filename)
  return current_filename:match("%.md$") ~= nil
end

local run_command = function(cmd)
  local result = vim.fn.systemlist(cmd)
  local out = ""

  if #result > 0 then
    for _, line in ipairs(result) do
      out = string.format("%s %s", out, line:gsub("%s+$", ""))
    end

    if string.match(out, "Error:") then
      return false
    end
  end
  return true
end

function MarkdownPreview()
  local current_abs_path = get_current_file()
  if current_abs_path == nil then
    print("No file is open")
    return
  end

  local filename = get_filename(current_abs_path)

  local is_md = check_md_file(current_abs_path)
  if is_md == false then
    print("File is not markdown")
    return
  end

  local command = string.format("$HOME/.local/bin/markdown_preview --open %s 2>&1 > /dev/null 2>&1", current_abs_path)
  local ok = run_command(command)

  if not ok then
    print("Error executing markdown preview")
  else
    print("Preview is updated for " .. filename)
  end
end

function SaveMarkdownPreview()
  local current_abs_path = get_current_file()
  if current_abs_path == nil then
    print("No file is open")
    return
  end

  local filename = get_filename(current_abs_path)

  local is_md = check_md_file(current_abs_path)
  if is_md == false then
    print("File is not markdown")
    return
  end

  local command = string.format("$HOME/.local/bin/markdown_preview --save %s 2>&1 >/dev/null 2>&1", current_abs_path)

  local ok = run_command(command)

  if not ok then
    print("Error executing saving markdown preview")
  else
    print("Preview is saved for " .. filename .. " in the current directory")
  end
end

local M = {}

M.MarkdownPreview = MarkdownPreview
M.SaveMarkdownPreview = SaveMarkdownPreview

return M
