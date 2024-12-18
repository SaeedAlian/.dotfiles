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

local get_zathura_processes = function()
  local command = string.format("ps aux | grep \"$(pgrep zathura)\" | sed 's/.*zathura//'")
  local result = vim.fn.systemlist(command)
  local running_processes = ""

  if #result > 0 then
    for _, line in ipairs(result) do
      running_processes = string.format("%s %s", running_processes, line:gsub("%s+$", ""))
    end

    return running_processes
  else
    return nil
  end
end

local check_zathura_file_is_open = function(running_processes, filename)
  local pdf_filename = string.gsub(filename, ".md$", ".pdf")
  local matched = string.match(running_processes, pdf_filename)

  return matched
end

local markdown_preview = function()
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

  local running_processes = get_zathura_processes()
  if running_processes == nil then
    vim.cmd([[silent !pandoc % -o %:r.pdf && zathura %:r.pdf &]])
    print("Preview is on for " .. filename)
    return
  end

  if check_zathura_file_is_open(running_processes, filename) == nil then
    vim.cmd([[silent !pandoc % -o /tmp/%:r.pdf && zathura /tmp/%:r.pdf &]])
    print("Preview is on for " .. filename)
    return
  end

  vim.cmd([[silent !pandoc % -o /tmp/%:r.pdf &]])
  print("Preview is updated for " .. filename)
end

local save_markdown_preview = function()
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

  vim.cmd([[:w | !pandoc % -o %:r.pdf &]])
  print("Preview is saved for " .. filename .. " in the current directory")
end

local M = {}

M.markdown_preview = markdown_preview
M.save_markdown_preview = save_markdown_preview

return M
