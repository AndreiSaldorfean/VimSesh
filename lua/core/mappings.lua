--- Comment
vim.keymap.set({ 'n', 'i' }, '<C-_>', '<esc>:Commentary<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<C-_>', ':Commentary<CR>gv', { noremap = true, silent = true })

---- ESCAPE
vim.keymap.set('t', '<esc>', '<C-\\><C-n>', { noremap = true, silent = true })

---- Terminal
vim.keymap.set({ 'n', 't', 'i' }, '<C-f>', '<C-\\><C-n>:ToggleTerm size=10 direction=horizontal<cr>',
  { noremap = true, silent = true })

----Open diff view
vim.keymap.set({ 'n', 'v' }, '<C-r>', '<ESC>:DiffviewOpen<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-q>', '<ESC>:DiffviewClose<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-q>', '<ESC>:DiffviewClose<CR>', { noremap = true, silent = true })

---- Remove highlight
vim.keymap.set({ 'n', 'v' }, '<leader>h', '<ESC>:nohl<CR>', { noremap = true, silent = true })

----Telescope
vim.keymap.set({ 'n', 'v' }, '<leader>f', '<ESC>:Telescope grep_string<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', ':Telescope find_files<cr>', { noremap = true, silent = true })

----Git signs
vim.keymap.set({ 'n', 'v' }, '<leader>g', '<ESC>:Gitsigns blame_line<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-Down>', '<ESC>:Gitsigns next_hunk<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-Up>', '<ESC>:Gitsigns prev_hunk<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>q', '<ESC>:Gitsigns preview_hunk<CR>', { noremap = true, silent = true })

--  NeoTree
vim.keymap.set({ 'n', 'v' }, '<leader>e', '<ESC>:Neotree toggle<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, ';', '<ESC>:Neogit<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<Tab>', '>>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', '<<', { noremap = true, silent = true })

-- Map <Tab> to indent and <S-Tab> to unindent in visual mode
vim.keymap.set('v', '<Tab>', ">gv", { noremap = true, silent = true })
vim.keymap.set('v', '<S-Tab>', "<gv", { noremap = true, silent = true })

--Save/Quit
vim.keymap.set({ 'n', 'v', 'i' }, '<C-s>', "<C-\\><C-n>:w!<CR>", { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'qq', '<C-\\><C-n>:qa!<CR>', { noremap = true, silent = true })

-- Vscode move up/down
vim.keymap.set('n', '<A-Up>', ":m-2<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<A-Down>', ":m+1<CR>", { noremap = true, silent = true })
vim.keymap.set('i', '<A-Up>', "<C-o>d:m-2<CR>", { noremap = true, silent = true })
vim.keymap.set('i', '<A-Down>', "<C-o>d:m+1<CR>", { noremap = true, silent = true })
vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv", { noremap = true, silent = true })
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv", { noremap = true, silent = true })

-- Move between tabs
vim.keymap.set('n', '<A-h>', ":BufferPrevious<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<A-l>', ":BufferNext<CR>", { noremap = true, silent = true })

-- Move between windows
vim.keymap.set('n', '<S-k>', "<C-w>k<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<S-j>', "<C-w>j<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<S-h>', "<C-w>h<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<S-l>', "<C-w>l<CR>", { noremap = true, silent = true })

-- Hop
vim.keymap.set('n', 'f', ":HopChar1<CR>", { noremap = true, silent = true })
vim.keymap.set('n', 't', ":HopPattern<CR>", { noremap = true, silent = true })

-- DAP
vim.keymap.set('n', '<F5>', ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F10>', ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F9>', ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<Space>b', ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })

-- LSP
vim.keymap.set('n', 'R', '<cmd>lua vim.lsp.buf.rename()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', { noremap = true, silent = true })
