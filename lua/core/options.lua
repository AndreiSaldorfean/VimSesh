vim.o.mouse = 'a'

-- Folds
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldenable = true

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
opt.termguicolors = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = false

-- stuff
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- splitting windows
opt.splitright = true
opt.splitbelow = true

-- hide ~ on empty line
opt.fillchars = { eob = " " }

