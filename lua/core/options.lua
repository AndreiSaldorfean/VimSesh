vim.o.mouse = 'a'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Folds
vim.o.foldcolumn = '1' -- '0' is not bad
vim.opt.foldlevel = 99
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99

vim.cmd("let g:netrw_liststyle = 3")

-- appearence
vim.g.flog_enable_extended_chars = 1
vim.opt.laststatus = 0
vim.opt.colorcolumn = '120'
vim.cmd("colorscheme vscode")
vim.cmd [[highlight ColorColumn ctermbg=grey guibg=#1d1f21]]

local opt = vim.opt
-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.autoindent = true

opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = false

-- stuff
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- splitting windows
opt.splitright = true
opt.splitbelow = true

-- hide ~ on empty line
opt.fillchars = { eob = " " }
