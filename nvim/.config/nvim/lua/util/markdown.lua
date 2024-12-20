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

local check_zathura_file_is_open = function(running_processes, pdf_filename)
  local matched = string.match(running_processes, pdf_filename)

  return matched
end

local function run_command(cmd)
  local result = io.popen(cmd)

  if not result then
    return false
  end

  local ok = result:close()
  io.close()

  return ok
end

function UpdateMarkdownPreview()
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
    return
  end

  local pdf_filename = string.gsub(filename, ".md$", ".pdf")

  if check_zathura_file_is_open(running_processes, pdf_filename) == nil then
    return
  end

  local command = string.format("pandoc %s -o /tmp/%s 2>&1 > /dev/null 2>&1", current_abs_path, pdf_filename)
  local ok = run_command(command)

  if not ok then
    print("Error executing markdown preview")
  else
    print("Preview is updated for " .. filename)
  end
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

  local pdf_filename = string.gsub(filename, ".md$", ".pdf")

  local open_command = string.format(
    "pandoc %s -o /tmp/%s 2>&1 > /dev/null 2>&1 && zathura /tmp/%s &",
    current_abs_path,
    pdf_filename,
    pdf_filename
  )
  local update_command = string.format("pandoc %s -o /tmp/%s 2>&1 > /dev/null 2>&1", current_abs_path, pdf_filename)

  local running_processes = get_zathura_processes()
  if running_processes == nil then
    local ok = run_command(open_command)

    if not ok then
      print("Error executing markdown preview")
    else
      print("Preview is on for " .. filename)
    end

    return
  end

  if check_zathura_file_is_open(running_processes, pdf_filename) == nil then
    local ok = run_command(open_command)

    if not ok then
      print("Error executing markdown preview")
    else
      print("Preview is on for " .. filename)
    end

    return
  end

  local ok = run_command(update_command)

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

  local pdf_filename = string.gsub(filename, ".md$", ".pdf")

  local command = string.format("pandoc %s -o %s 2>&1 > /dev/null 2>&1", current_abs_path, pdf_filename)

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
M.UpdateMarkdownPreview = UpdateMarkdownPreview

return M
