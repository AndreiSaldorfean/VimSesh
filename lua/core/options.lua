vim.cmd("let g:netrw_liststyle = 3")

vim.o.directory = "~/.local/state/nvim/swap//"
vim.diagnostic.config({
  virtual_text = {
    prefix = '■', -- Change this to match the icon in your screenshot
    spacing = 4,
  },
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
})

-- You can also configure the signs displayed in the sign column
vim.fn.sign_define("DiagnosticSignError", {text = "X", numhl = "DiagnosticError"})
vim.fn.sign_define("DiagnosticSignWarn", {text = "⚠", numhl = "DiagnosticWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text = "i", numhl = "DiagnosticInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text = "!", numhl = "DiagnosticHint"})

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

    
