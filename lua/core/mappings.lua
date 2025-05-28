--- Comment
-- vim.keymap.set({ 'n', 'i' }, '<C-/>', '<esc>:Commentary<CR>', { noremap = true, silent = true })
-- vim.keymap.set('v', '<C-/>', ':Commentary<CR>gv', { noremap = true, silent = true })
-- vim.keymap.set({ 'n', 'i' }, '<C-_>', '<esc>:Commentary<CR>', { noremap = true, silent = true })
-- vim.keymap.set('v', '<C-_>', ':Commentary<CR>gv', { noremap = true, silent = true })

---- ESCAPE
vim.keymap.set('t', '<esc>', '<C-\\><C-n>', { noremap = true, silent = true })

---- Remove highlight
vim.keymap.set({ 'n', 'v' }, '<leader>h', '<ESC>:nohl<CR>', { noremap = true, silent = true })

----Telescope
vim.keymap.set({ 'n', 'v' }, '<leader>f', ':FzfLua grep_project<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', ':FzfLua files<cr>', { noremap = true, silent = true })

----Git signs
vim.keymap.set({ 'n', 'v' }, '<S-s>',     '<ESC>:Gitsigns stage_hunk<CR>',      { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<S-f>',     '<ESC>:Gitsigns preview_hunk_inline<CR>',    { noremap = true, silent = true })
-- vim.keymap.set({ 'n', 'v' }, '<leader>e', '<ESC>:Neotree toggle<CR>',           { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<F1>',      '<ESC>:SessionLoad<CR>',              { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>r', '<ESC>:DiffviewOpen<CR>',             { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>t', '<ESC>:DiffviewClose<CR>',            { noremap = true, silent = true })

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

-- Hop
vim.keymap.set('n', 'f', ":HopChar1<CR>", { noremap = true, silent = true })
vim.keymap.set('n', 't', ":HopPattern<CR>", { noremap = true, silent = true })

-- LSP
vim.keymap.set('n', '<A-o>', ':ClangdSwitchSourceHeader<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'R', '<cmd>lua vim.lsp.buf.rename()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>',
  { noremap = true, silent = true })
vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>',
  { noremap = true, silent = true })

vim.keymap.set('n', '<C-a>', ':%y+<CR>', { noremap = true, silent = true })
vim.cmd('noremap q: :')
vim.cmd('noremap <S-Down> j')
vim.cmd('noremap <S-Up> k')
vim.cmd('noremap q/ /')
vim.keymap.set("n", "<C-z>", "<Nop>", { noremap = true, silent = true })

-- BARBAR
vim.keymap.set({ 'n' }, '<S-h>', ':bp<cr>', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<S-l>', ':bn<cr>', { noremap = true, silent = true })

--Terminal
local Terminal = require("toggleterm.terminal").Terminal
local float_term = Terminal:new({
  direction = "float",
  hidden = true,
  on_open = function(term)
    vim.cmd("startinsert!")
  end,
})

vim.keymap.set({ "n", "i", "t" }, "<C-f>", function()
  float_term:toggle()
end, { noremap = true, silent = true })

-- Copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-o>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
vim.keymap.set("n", "<C-i>", "<C-i>", { noremap = true })

