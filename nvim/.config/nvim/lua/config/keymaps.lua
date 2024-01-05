local map = require("util.keymapper").map

-- remove some keymaps
map("n", "Q", "<nop>", "Remove Q")
map({ "v", "i", "n" }, "<Down>", "<nop>", "Remove down arrow key")
map({ "v", "i", "n" }, "<Left>", "<nop>", "Remove left arrow key")
map({ "v", "i", "n" }, "<Right>", "<nop>", "Remove right arrow key")
map({ "v", "i", "n" }, "<Up>", "<nop>", "Remove up arrow key")

-- Move to the end of line and exclude the \n at the end
map("v", "$", "$<Left>", "Move to the end of line and exclude the \n at the end")

-- delete character without yanking it
map("n", "x", [["_x]], "Delete single character after cursor without yanking")
map("n", "X", [["_X]], "Delete single character before cursor without yanking")

-- increment/decrement
map({ "n", "v" }, "+", "<C-a>", "Increment")
map({ "n", "v" }, "-", "<C-x>", "Decrement")
map("v", "g+", "g<C-a>", "Incremental increment")
map("v", "g-", "g<C-x>", "Decremental decrement")

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

-- select all
map("n", "<C-a>", "gg<S-v>G", "Select all")

-- tmux session fuzzy finder
-- only works when tmux is installed
map("n", "<C-f>", "<cmd>silent !tmux neww ~/scripts/tmux_fzf_session<CR>", "Start tmux session fuzzy finder")

-- make the current file an executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", "Make the current file an executable", { silent = true })

-- move the visually selected lines up and down
map("v", "J", ":m '>+1<CR>gv=gv", "Move the visually selected lines down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move the visually selected lines up")

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
map("n", "<C-w>", ":Bdelete <CR>", "Close buffer") -- close buffer
map("n", "<leader><C-w>", ":Bdelete! <CR>", "Force close buffer") -- force close buffer

-- indenting
map("v", "<", "<gv", "Indent right", { silent = true })
map("v", ">", ">gv", "Indent left", { silent = true })

-- toggle wrap
map("n", "<leader>wt", ":set wrap!<Return>", "Toggle wrap line")

-- git
map("n", "<leader>gs", ":Git<CR>", "Git status")
map("n", "<leader>gc", ":Git commit<CR>", "Git status")

-- undotree
map("n", "<leader>uf", ":UndotreeFocus<CR>", "Undo tree focus")
map("n", "<leader>u", function()
	vim.cmd.UndotreeToggle()
	vim.cmd.UndotreeFocus()
end, "Undo tree toggle")

-- directory navigation
map("n", "<leader>pd", ":NvimTreeFocus<Return>")
map("n", "<leader>t", ":NvimTreeToggle<Return>")
