local map = require("utils.keymapper").map

-- -- -- -- start config -- -- -- --

-- -- augroups -- --

local main_group = vim.api.nvim_create_augroup("main", { clear = true })
local statusline_group = vim.api.nvim_create_augroup("statusline", { clear = true })
local netrw_group = vim.api.nvim_create_augroup("netrw", { clear = true })

-- -- globals -- --

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.autoformat = true

-- -- netrw -- --

vim.g.netrw_liststyle = 0
vim.g.netrw_winsize = 25
vim.g.netrw_localcopydircmd = "cp -r"

function ToggleNetRWWindow()
	if vim.bo.filetype == "netrw" then
		local count = 0
		while vim.bo.filetype == "netrw" do
			if count > 4 then
				vim.api.nvim_command("bdel")
				break
			end
			vim.api.nvim_command("Rex")
			count = count + 1
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

-- netrw keymaps
vim.api.nvim_create_autocmd("FileType", {
	group = netrw_group,
	pattern = "netrw",
	callback = function()
		map("n", "<Esc>", "<CMD>ToggleNetRW<CR>", "Toggle netrw", { noremap = true, silent = true, buffer = true })
		map("n", "s", "<Nop>", "Disable sort in netrw", { noremap = true, silent = true, buffer = true })
		map("n", "r", "<Nop>", "Disable reverse sort in netrw", { noremap = true, silent = true, buffer = true })
		map("n", "<C-l>", "<C-w><C-l>", "Fix move to left split", { noremap = true, silent = true, buffer = true })
		map(
			"n",
			"P",
			"<CMD>Ex " .. vim.fn.getcwd() .. "<CR>",
			"Explore cwd",
			{ remap = true, silent = true, buffer = true }
		)
	end,
})

-- -- autocmds -- --

-- set textwidth to 100 for Markdown and Typst files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "typst" },
	group = main_group,
	callback = function()
		vim.opt_local.textwidth = 100
	end,
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = main_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- autoformat on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		if vim.g.autoformat then
			require("conform").format({ bufnr = args.buf, timeout_ms = 5000 })
		end
	end,
})

-- -- options -- --

-- tabs and indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- fast update time
vim.opt.updatetime = 50

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ui
vim.opt.nu = true
vim.opt.winborder = "rounded"
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.cmdheight = 1
vim.opt.scrolloff = 12
vim.opt.colorcolumn = "130"
vim.opt.signcolumn = "yes"
vim.opt.completeopt = { "menu", "menuone", "noselect", "fuzzy" }
vim.opt.guicursor = "n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"
vim.opt.pumheight = 5
vim.opt.showmode = false

-- backup and undo directory
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- behaviour
vim.opt.errorbells = false
vim.opt.hidden = true
vim.opt.backspace = "indent,eol,start"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.autochdir = false
vim.opt.modifiable = true
vim.opt.mouse = ""
vim.opt.clipboard:append({ "unnamedplus" })
vim.opt.encoding = "UTF-8"
vim.opt.fileencoding = "UTF-8"
vim.scriptencoding = "UTF-8"
vim.opt.iskeyword = "@,-,_,48-57,192-255"
vim.opt.wildignore:append({ "*/node_modules/*" })

-- -- keymaps -- --

-- remove some keymaps
map("n", "Q", "<nop>", "Remove Q")
map({ "v", "i", "n" }, "<Down>", "<nop>", "Remove down arrow key")
map({ "v", "i", "n" }, "<Left>", "<nop>", "Remove left arrow key")
map({ "v", "i", "n" }, "<Right>", "<nop>", "Remove right arrow key")
map({ "v", "i", "n" }, "<Up>", "<nop>", "Remove up arrow key")

-- move to the end of line and exclude the \n at the end
map("v", "$", "$<Left>", "Move to the end of line and exclude the \n at the end")

-- delete character without yanking it
map("n", "x", [["_x]], "Delete single character after cursor without yanking")
map("n", "X", [["_X]], "Delete single character before cursor without yanking")

-- delete with yanking (same as default deletion in vim)
map({ "n", "v" }, "<leader>d", [["+d]], "Delete with yanking")
map({ "n", "v" }, "<leader>D", [["+d$]], "Delete to the end of line with yanking")
map({ "n", "v" }, "<leader>c", [["+c]], "Delete and go to insert mode with yanking")
map({ "n", "v" }, "<leader>C", [["+c$]], "Delete to the end of line and go to insert mode with yanking")

-- delete without yanking
map({ "n", "v" }, "d", [["_d]], "Delete without yanking")
map({ "n", "v" }, "D", [["_d$]], "Delete to the end of line without yanking")
map({ "n", "v" }, "c", [["_c]], "Delete and got to insert mode without yanking")
map({ "n", "v" }, "C", [["_c$]], "Delete to the end of line and go to insert mode without yanking")

-- tmux session fuzzy finder
-- only works when tmux is attached
map("n", "<C-f>", "<cmd>silent !tmux neww ~/.local/bin/tools/tmux_fzf_session<CR>", "Start tmux session fzf")

-- move the visually selected lines up and down
map("v", "J", ":m '>+1<CR>gv=gv", "Move the visually selected lines down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move the visually selected lines up")

-- navigating splits
map("n", "<C-j>", "<C-w><C-j>", "Navigate to bottom split")
map("n", "<C-k>", "<C-w><C-k>", "Navigate to top split")
map("n", "<C-l>", "<C-w><C-l>", "Navigate to right split")
map("n", "<C-h>", "<C-w><C-h>", "Navigate to left split")

-- rename selected word globally
map(
	"v",
	"<leader>r",
	[["hy:<C-w>%s/\(<C-r>h\)/<C-r>h/gI<Left><Left><Left>]],
	"Rename selected word (visually) globally"
)
map(
	"n",
	"<leader>r",
	[[:%s/\(<C-r><C-w>\)/<C-r><C-w>/gI<Left><Left><Left>]],
	"Rename selected word (under cursor) globally"
)

-- force the cursor to be the same place when using J to move the lines into one line
map("n", "J", "mzJ`z", "Normal J, but the cursor stays fixed")

-- centerize window when using <C-u> or <C-d> to jump half of the buffer
map("n", "<C-d>", "<C-d>zz", "Move half page down")
map("n", "<C-u>", "<C-u>zz", "Move half page up")

-- centerize window when using n or N to do the incremental search
map("n", "n", "nzzzv", "Incremental search forward")
map("n", "N", "Nzzzv", "Incremental search backward")

-- window management
map("n", "sv", ":vsplit<Return>", "Vertical split") -- vertical split
map("n", "ss", ":split<Return>", "Horizontal split") -- horizontal split
map("n", "<A-h>", "<C-w><", "Resize pane left side") -- resize left
map("n", "<A-k>", "<C-w>+", "Resize pane up side") -- resize up
map("n", "<A-l>", "<C-w>>", "Resize pane right side") -- resize right
map("n", "<A-j>", "<C-w>-", "Resize pane down side") -- resize down

-- buffer management
map("n", "<tab>", ":bnext<Return>", "Next buffer") -- next buffer
map("n", "<s-tab>", ":bprev<Return>", "Previous buffer") -- previous buffer

-- indenting
map("v", "<", "<gv", "Indent right", { silent = true })
map("v", ">", ">gv", "Indent left", { silent = true })

-- toggle wrap
map("n", "<leader>wt", ":set wrap!<Return>", "Toggle wrap line")

-- git
map("n", "<leader>gs", ":Git<CR>", "Git status")
map("n", "<leader>gc", ":Git commit<CR>", "Git commit")
map("n", "<leader>gp", ":Git push<CR>", "Git push")

-- undotree
map("n", "<leader>uf", ":UndotreeFocus<CR>", "Undo tree focus")
map("n", "<leader>u", function()
	vim.cmd.UndotreeToggle()
	vim.cmd.UndotreeFocus()
end, "Undo tree toggle")

-- fzf picker
map("n", "<leader>pf", ":Telescope find_files<CR>", "Search through files with telescope")
map("n", "<leader>lg", ":Telescope live_grep<CR>", "Search with live grep in telescope")
map("n", "<leader>pt", function()
	local builtin = require("telescope.builtin")
	builtin.treesitter()
end, "Search through variables, functions etc. in a code buffer which has treesitter with telescope")

-- vim maximizer
map("n", "sm", "<cmd>MaximizerToggle<CR>", "Maximize/Minimize a split buffer")

-- file explorer
map("n", "<leader>pd", ":ToggleNetRW<CR>", "Toggle file explorer")

-- toggle autoformat on save
map("n", "<leader>af", function()
	if vim.g.autoformat then
		vim.g.autoformat = false
		print("Autoformat turned off")
	else
		vim.g.autoformat = true
		print("Autoformat turned on")
	end
end, "Toggle auto format")

-- format buffer
map({ "n", "v" }, "<leader>f", function()
	if vim.g.autoformat then
		require("conform").format({ timeout_ms = 10000, async = true })
	end
end, "Format buffer")

-- -- statusline -- --

local function git_branch()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns and gitsigns.head and gitsigns.head ~= "" then
		return " " .. gitsigns.head
	end
	local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
	return (branch ~= "" and (" " .. branch)) or ""
end

local function file_type()
	local ft = vim.bo.filetype
	return ft
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
		return size .. "B"
	elseif size < 1024 * 1024 then
		return string.format("%.1fK", size / 1024)
	else
		return string.format("%.1fM", size / (1024 * 1024))
	end
end

local function mode_color()
	local mode = vim.fn.mode()
	local mode_colors = {
		n = "%#StatusLineNormal#",
		i = "%#StatusLineInsert#",
		v = "%#StatusLineVisual#",
		V = "%#StatusLineVisualLine#",
		["\22"] = "%#StatusLineVisualBlock#",
		c = "%#StatusLineCommand#",
		R = "%#StatusLineReplace#",
		t = "%#StatusLineTerminal#",
	}
	return mode_colors[mode] or ""
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
		R = "REPLACE",
		t = "TERMINAL",
	}
	return modes[mode] or mode:upper()
end

local function set_diagnostics()
	local buf = vim.api.nvim_get_current_buf()
	local counts = vim.diagnostic.count(buf)

	local errs = counts[vim.diagnostic.severity.ERROR] or 0
	local warns = counts[vim.diagnostic.severity.WARN] or 0
	local info = counts[vim.diagnostic.severity.INFO] or 0
	local hints = counts[vim.diagnostic.severity.HINT] or 0

	local new_str = ""

	if errs > 0 then
		new_str = string.format("%sE %d ", new_str, errs)
	end

	if warns > 0 then
		new_str = string.format("%sW %d ", new_str, warns)
	end

	if info > 0 then
		new_str = string.format("%sI %d ", new_str, info)
	end

	if hints > 0 then
		new_str = string.format("%sH %d ", new_str, hints)
	end

	return new_str
end

local function modified_flag()
	return vim.bo.modified and "  [+]" or ""
end

_G.mode_icon = mode_icon
_G.modified_flag = modified_flag
_G.set_diagnostics = set_diagnostics
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size
_G.file_name = file_name

-- statusline
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "ModeChanged" }, {
	group = statusline_group,
	callback = function()
		vim.api.nvim_set_hl(0, "StatusLineNormal", { fg = "#14151B", bg = "#7190D3", bold = true })
		vim.api.nvim_set_hl(0, "StatusLineInsert", { fg = "#14151B", bg = "#98C379", bold = true })
		vim.api.nvim_set_hl(0, "StatusLineVisual", { fg = "#14151B", bg = "#DD9CF0", bold = true })
		vim.api.nvim_set_hl(0, "StatusLineVisualLine", { fg = "#CED1D9", bg = "#8800B0", bold = true })
		vim.api.nvim_set_hl(0, "StatusLineVisualBlock", { fg = "#14151B", bg = "#C100F9", bold = true })
		vim.api.nvim_set_hl(0, "StatusLineCommand", { fg = "#14151B", bg = "#D5916E", bold = true })
		vim.api.nvim_set_hl(0, "StatusLineReplace", { fg = "#14151B", bg = "#D27078", bold = true })
		vim.api.nvim_set_hl(0, "StatusLineTerminal", { fg = "#14151B", bg = "#CED1D9", bold = true })

		vim.opt_local.statusline = table.concat({
			mode_color() .. " %{v:lua.mode_icon()} ",
			"%#StatusLine#",
			" %{v:lua.file_name()}%{v:lua.modified_flag()} ",
			"│ %{v:lua.git_branch()} ",
			"│ %{v:lua.file_type()} ",
			"│ %{v:lua.file_size()} ",
			"│ %{v:lua.set_diagnostics()} ",
			"%=",
			"%l ",
		})
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = statusline_group,
	callback = function()
		vim.api.nvim_set_hl(0, "StatusLineDim", { fg = "#82838C", bg = "#212329", bold = true })

		vim.opt_local.statusline = "%#StatusLineDim# %{v:lua.file_name()} │ %{v:lua.file_type()} %= Ln %l, Col %c "
	end,
})

-- -- -- -- end config -- -- -- --
