function GetCurrentFile()
  local current_filename = vim.api.nvim_buf_get_name(0)

  if current_filename == "" then
    return nil
  end

  return current_filename
end

function GetFilename(absolute_path)
  return string.gsub(absolute_path, ".*/", "")
end

function CheckMDFile(current_filename)
  return current_filename:match("%.md$") ~= nil
end

function CheckTypFile(current_filename)
  return current_filename:match("%.typ$") ~= nil
end

local function split_command(cmd_str)
  local t = {}
  for word in string.gmatch(cmd_str, "%S+") do
    table.insert(t, word)
  end
  return t
end

function RunCMD(cmd)
  local result = vim.system(split_command(cmd), { text = true }):wait()

  local stdout = result.stdout
  local stderr = result.stderr
  local code = result.code

  return stdout, stderr, code, stderr == ""
end

local M = {}

M.GetCurrentFile = GetCurrentFile
M.CheckTypFile = CheckTypFile
M.CheckMDFile = CheckMDFile
M.GetFilename = GetFilename
M.RunCMD = RunCMD

return M
