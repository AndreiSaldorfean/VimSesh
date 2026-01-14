---- ESCAPE
vim.keymap.set('t', '<esc>', '<C-\\><C-n>', { noremap = true, silent = true })

---- Remove highlight
vim.keymap.set({ 'n', 'v' }, '<leader>h', '<ESC>:nohl<CR>', { noremap = true, silent = true })

vim.keymap.set({ 'n', 'v' }, '!', '<ESC>#*zz', { noremap = true, silent = true })

-- Neotree
vim.keymap.set({ 'n', 'v' }, '<leader>e', '<ESC>:Neotree toggle<CR>',           { noremap = true, silent = true })

----Telescope
vim.keymap.set({ 'n', 'v' }, '<leader>f', ':FzfLua live_grep<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', ':FzfLua files<cr>', { noremap = true, silent = true })

----Git signs
vim.keymap.set({ 'n' }, '<leader>j', '<ESC>:Gitsigns next_hunk<CR>',     { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<leader>k', '<ESC>:Gitsigns prev_hunk<CR>',     { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<leader>r', '<ESC>:Gitsigns reset_hunk<CR>',    { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<leader>p', '<ESC>:Gitsigns preview_hunk_inline<CR>',    { noremap = true, silent = true })

-- Map <Tab> to indent and <S-Tab> to unindent in visual mode
vim.keymap.set('v', '<Tab>', ">gv", { noremap = true, silent = true })
vim.keymap.set('v', '<S-Tab>', "<gv", { noremap = true, silent = true })

--Save/Quit
vim.keymap.set({ 'n','v','i'}, '<C-s>', "<C-\\><C-n>:up!<CR>", { noremap = true, silent = true })
vim.keymap.set({ 'n','v','i'}, 'qq', ":qa!<cr>", { noremap = true, silent = true })

-- Vscode move up/down
vim.keymap.set('n', '<A-k>',    ':m-2<CR>',          { noremap = true, silent = true })
vim.keymap.set('n', '<A-j>',    ':m+1<CR>',          { noremap = true, silent = true })
vim.keymap.set('i', '<A-k>',    '<C-o>d:m-2<CR>',    { noremap = true, silent = true })
vim.keymap.set('i', '<A-j>',    '<C-o>d:m+1<CR>',    { noremap = true, silent = true })
vim.keymap.set('v', '<A-k>',    ':m \'<-2<CR>gv',    { noremap = true, silent = true })
vim.keymap.set('v', '<A-j>',    ':m \'>+1<CR>gv',    { noremap = true, silent = true })
vim.keymap.set('n', '<A-Up>',   ':m-2<CR>',          { noremap = true, silent = true })
vim.keymap.set('n', '<A-Down>', ':m+1<CR>',          { noremap = true, silent = true })
vim.keymap.set('i', '<A-Up>',   '<C-o>d:m-2<CR>',    { noremap = true, silent = true })
vim.keymap.set('i', '<A-Down>', '<C-o>d:m+1<CR>',    { noremap = true, silent = true })
vim.keymap.set('v', '<A-Up>',   ':m \'<-2<CR>gv',    { noremap = true, silent = true })
vim.keymap.set('v', '<A-Down>', ':m \'>+1<CR>gv',    { noremap = true, silent = true })
vim.keymap.set('n', '<S-q>',    ':BufferClose<cr>',  { noremap = true, silent = true })

-- LSP
vim.keymap.set('n', '<A-o>', ':Ouroboros<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'R', '<cmd>lua vim.lsp.buf.rename()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', { noremap = true, silent = true })

-- Folding
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

vim.keymap.set('n', '<C-a>', ':%y+<CR>', { noremap = true, silent = true })
vim.cmd('noremap q: :')
vim.cmd('noremap <S-Down> j')
vim.cmd('noremap <S-Up> k')
vim.cmd('noremap q/ /')
vim.keymap.set("n", "<C-z>", ":undo<CR>", { noremap = true, silent = true })

-- BARBAR
vim.keymap.set({ 'n' }, '<S-h>', ':BufferPrevious<cr>', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<S-l>', ':BufferNext<cr>', { noremap = true, silent = true })

--Terminal
local Terminal = require("toggleterm.terminal").Terminal
local float_term = Terminal:new({
  direction = "float",
  hidden = true,
  vim.o.shell,
  on_open = function(term)
    vim.cmd("startinsert!")
  end,
})

vim.keymap.set({ "n", "i", "t" }, "<C-f>", function()
  float_term:toggle()
end, { noremap = true, silent = true })
