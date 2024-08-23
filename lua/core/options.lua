vim.cmd("let g:netrw_liststyle = 3")

-- appearence
vim.opt.colorcolumn = '120'
vim.cmd("colorscheme cyberdream")
vim.cmd [[highlight ColorColumn ctermbg=lightgrey guibg=grey]]
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

    
