local helpers = require("util.helpers")

function TypstPreview()
	local current_abs_path = helpers.GetCurrentFile()
	if current_abs_path == nil then
		print("No file is open")
		return
	end

	local filename = helpers.GetFilename(current_abs_path)

	local is_md = helpers.CheckTypFile(current_abs_path)
	if is_md == false then
		print("File is not typ")
		return
	end

	local command = string.format("typst_preview --open %s", current_abs_path)
	local _, stderr, _, ok = helpers.RunCMD(command)

	if not ok then
		print("Error executing typst preview: ", stderr)
	else
		print("Preview is updated for " .. filename)
	end
end

function SaveTypstPreview()
	local current_abs_path = helpers.GetCurrentFile()
	if current_abs_path == nil then
		print("No file is open")
		return
	end

	local filename = helpers.GetFilename(current_abs_path)

	local is_md = helpers.CheckTypFile(current_abs_path)
	if is_md == false then
		print("File is not typ")
		return
	end

	local command = string.format("typst_preview --save %s", current_abs_path)
	local _, stderr, _, ok = helpers.RunCMD(command)

	if not ok then
		print("Error executing saving typst preview: ", stderr)
	else
		print("Preview is saved for " .. filename .. " in the current directory")
	end
end

local M = {}

M.TypstPreview = TypstPreview
M.SaveTypstPreview = SaveTypstPreview

return M
