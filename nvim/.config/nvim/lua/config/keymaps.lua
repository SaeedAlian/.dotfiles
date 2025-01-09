local map = require("util.keymapper").map
local MarkdownPreview = require("util.markdown").MarkdownPreview
local SaveMarkdownPreview = require("util.markdown").SaveMarkdownPreview

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
map("n", "<C-f>", "<cmd>silent !tmux neww ~/.local/bin/tmux_fzf_session<CR>", "Start tmux session fzf")

-- launch dnote in prompt mode
-- only works when tmux is attached
map("n", "<C-p>", "<cmd>silent !tmux neww ~/.local/bin/dnote -p<CR>", "Start tmux session fzf")

-- launch dnote in fzf notes
-- only works when tmux is attached
map("n", "<C-n><C-n>", "<cmd>silent !tmux neww ~/.local/bin/dnote -f<CR>", "Start tmux session fzf")

-- launch dnote in fzf all notes
-- only works when tmux is attached
map("n", "<C-n><C-a>", "<cmd>silent !tmux neww ~/.local/bin/dnote -af<CR>", "Start tmux session fzf")

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

-- telescope
map("n", "<leader>vh", ":Telescope help_tags<CR>", "Search through tags with telescope")
map("n", "<leader>pf", ":Telescope find_files<CR>", "Search through files with telescope")
map("n", "<leader>pg", ":Telescope git_files<CR>", "Search through git files with telescope")
map("n", "<leader>lg", ":Telescope live_grep<CR>", "Search with live grep in telescope")
map("n", "<leader>pb", ":Telescope buffers<CR>", "Search through buffers with telescope")
map("n", "<leader>pt", function()
	local builtin = require("telescope.builtin")
	builtin.treesitter()
end, "Search through variables, functions etc. in a code buffer which has treesitter with telescope")
map("n", "<leader>pD", function()
	local builtin = require("telescope.builtin")
	builtin.diagnostics()
end, "Search through diagnostics with telescope")

-- vim maximizer
map("n", "sm", "<cmd>MaximizerToggle<CR>", "Maximize/Minimize a split buffer")

-- vim/tmux navigator
map("n", "<C-h>", "<cmd><C-U>TmuxNavigateLeft<CR>", "Vim/Tmux pane navigate left")
map("n", "<C-j>", "<cmd><C-U>TmuxNavigateDown<CR>", "Vim/Tmux pane navigate down")
map("n", "<C-k>", "<cmd><C-U>TmuxNavigateUp<CR>", "Vim/Tmux pane navigate up")
map("n", "<C-l>", "<cmd><C-U>TmuxNavigateRight<CR>", "Vim/Tmux pane navigate right")
map("n", "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<CR>", "Vim/Tmux pane navigate previous")

-- lsp on attach
function LspOnAttach(_, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	map("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", "Show LSP references", opts)
	map("n", "<leader>gd", vim.lsp.buf.definition, "Go to definition", opts)
	map("n", "<leader>ca", vim.lsp.buf.code_action, "See available code actions", opts)
	map("n", "<leader>sr", vim.lsp.buf.rename, "Smart rename", opts)
	map("n", "<leader>ld", vim.diagnostic.open_float, "Show line diagnostics", opts)
	map("n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic", opts)
	map("n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic", opts)
	map("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor", opts)
end

-- format buffer
map("n", "<leader>f", function()
	vim.lsp.buf.format({ timeout_ms = 10000 })
end, "Format the current buffer", {})

-- render markdown toggle
map("n", "<leader>md", ":RenderMarkdown toggle<CR>", "Toggle render markdown")

-- preview markdown
map("n", "<leader>mp", function()
	MarkdownPreview()
end, "Markdown previewer with zathura and pandoc")

-- save markdown preview
map("n", "<leader>mds", function()
	SaveMarkdownPreview()
end, "Save markdown preview with pandoc in pdf format")

-- toggle autoformat on save
map("n", "<leader>af", function()
	if vim.g.autoformat then
		vim.g.autoformat = false
		print("Autoformat turned off")
	else
		vim.g.autoformat = true
		print("Autoformat turned on")
	end
end, "Save markdown preview with pandoc in pdf format")
