local helpers = require("utils.helpers")

function MarkdownPreview()
  local current_abs_path = helpers.GetCurrentFile()
  if current_abs_path == nil then
    print("No file is open")
    return
  end

  local filename = helpers.GetFilename(current_abs_path)

  local is_md = helpers.CheckMDFile(current_abs_path)
  if is_md == false then
    print("File is not markdown")
    return
  end

  local command = string.format("markdown_preview --open %s", current_abs_path)
  local _, stderr, _, ok = helpers.RunCMD(command)

  if not ok then
    print("Error executing markdown preview: ", stderr)
  else
    print("Preview is updated for " .. filename)
  end
end

function SaveMarkdownPreview()
  local current_abs_path = helpers.GetCurrentFile()
  if current_abs_path == nil then
    print("No file is open")
    return
  end

  local filename = helpers.GetFilename(current_abs_path)

  local is_md = helpers.CheckMDFile(current_abs_path)
  if is_md == false then
    print("File is not markdown")
    return
  end

  local command = string.format("markdown_preview --save %s", current_abs_path)
  local _, stderr, _, ok = helpers.RunCMD(command)

  if not ok then
    print("Error executing saving markdown preview: ", stderr)
  else
    print("Preview is saved for " .. filename .. " in the current directory")
  end
end

local M = {}

M.MarkdownPreview = MarkdownPreview
M.SaveMarkdownPreview = SaveMarkdownPreview

return M
