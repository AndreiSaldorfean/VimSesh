--- Comment
vim.keymap.set('n', '<C-_>', ':Commentary<CR>',{noremap = true, silent = true})
vim.keymap.set('i', '<C-_>', '<ESC>:Commentary<CR>a',{noremap = true, silent = true})
vim.keymap.set('v', '<C-_>', ':Commentary<CR>',{noremap = true, silent = true})

---- ESCAPE
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])

---- Terminal
vim.keymap.set('i', '<C-f>', '<ESC>:ToggleTerm size=10 direction=horizontal<cr>a',{noremap = true, silent = true})
vim.keymap.set('n', '<C-f>', ':ToggleTerm size=10 direction=horizontal<cr>a',{noremap = true, silent = true})
vim.keymap.set('t', '<C-f>', '<C-\\><C-n>:ToggleTerm size=10 direction=horizontal<cr>',{noremap = true, silent = true})

----Open diff view
vim.keymap.set({'n','v'}, '<C-r>', '<ESC>:DiffviewOpen<CR>',{noremap = true, silent = true})
vim.keymap.set({'n','v'}, '<C-q>', '<ESC>:DiffviewClose<CR>',{noremap = true, silent = true})
vim.keymap.set({'n','v'}, '<C-q>', '<ESC>:DiffviewClose<CR>',{noremap = true, silent = true})

---- Remove highlight
vim.keymap.set({'n','v'}, '<leader>h', '<ESC>:nohl<CR>',{noremap = true, silent = true})

----Telescope
vim.keymap.set({'n','v'}, '<leader>f', '<ESC>:Telescope grep_string<CR>',{noremap = true, silent = true})
vim.keymap.set('n', '<C-p>', ':Telescope find_files<cr>',{noremap = true, silent = true})

----Git signs
vim.keymap.set({'n','v'}, '<leader>g', '<ESC>:Gitsigns blame_line<CR>',{noremap = true, silent = true})
vim.keymap.set({'n','v'}, '<C-Down>', '<ESC>:Gitsigns next_hunk<CR>',{noremap = true, silent = true})
vim.keymap.set({'n','v'}, '<C-Up>', '<ESC>:Gitsigns prev_hunk<CR>',{noremap = true, silent = true})
vim.keymap.set({'n','v'}, '<leader>q', '<ESC>:Gitsigns preview_hunk<CR>',{noremap = true, silent = true})

--  NeoTree
vim.keymap.set({'n','v'}, '<leader>e', '<ESC>:Neotree toggle<CR>',{noremap = true, silent = true})
