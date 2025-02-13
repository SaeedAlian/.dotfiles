local opt = vim.opt

-- tabs and indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- fast update time
opt.updatetime = 50

-- search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- UI/GUI
opt.nu = true
opt.relativenumber = true
opt.termguicolors = true
opt.cmdheight = 1
opt.scrolloff = 12
opt.colorcolumn = "170"
opt.signcolumn = "yes"
opt.completeopt = "menuone,noinsert,noselect"
opt.guicursor = "n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"
opt.pumheight = 5
opt.showmode = false

-- backup and undo directory
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- behaviour
opt.errorbells = false
opt.hidden = true
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.autochdir = false
opt.modifiable = true
opt.mouse = ""
opt.clipboard:append({ "unnamedplus" })
opt.encoding = "UTF-8"
opt.fileencoding = "UTF-8"
vim.scriptencoding = "UTF-8"
opt.iskeyword = "@,-,_,48-57,192-255"
opt.wildignore:append({ "*/node_modules/*" })
