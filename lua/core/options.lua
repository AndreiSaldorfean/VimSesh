local links = {
  ['@lsp.type.namespace'] = '@namespace',
  ['@lsp.type.type'] = '@type',
  ['@lsp.type.class'] = '@type',
  ['@lsp.type.enum'] = '@type',
  ['@lsp.type.interface'] = '@type',
  ['@lsp.type.struct'] = '@structure',
  ['@lsp.type.parameter'] = '@parameter',
  ['@lsp.type.variable'] = '@variable',
  ['@lsp.type.property'] = '@property',
  ['@lsp.type.enumMember'] = '@constant',
  ['@lsp.type.function'] = '@function',
  ['@lsp.type.method'] = '@method',
  ['@lsp.type.macro'] = '@macro',
  ['@lsp.type.decorator'] = '@function',
}
for newgroup, oldgroup in pairs(links) do
  vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
end

for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end

vim.g.copilot_no_tab_map = true

vim.cmd("let g:netrw_liststyle = 3")

vim.diagnostic.config({
  virtual_text = {
    prefix = '■',
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

