-- Copy
vim.keymap.set('i', '<C-c>', '<Esc>yy<CR>')
vim.keymap.set('n', '<C-c>', 'yy')
vim.keymap.set('v', '<C-c>', 'ygv')
vim.keymap.set('t', '<C-c>', '<Esc>yy<CR>')

-- Paste
vim.keymap.set('i', '<C-v>', '<ESC>pa')
vim.keymap.set('n', '<C-v>', 'p')
vim.keymap.set('v', '<C-v>', 'p')
vim.keymap.set('t', '<C-v>', '<ESC>pa')

-- Undo
vim.keymap.set('i', '<C-z>', '<Esc>ua')
vim.keymap.set('n', '<C-z>', 'u')
vim.keymap.set('t', '<C-z>', '<Esc>ua')

--Redo
vim.keymap.set('n', '<C-y>', ':undo<Cr>')
vim.keymap.set('i', '<C-y>', '<ESC>:undo<Cr>a')
vim.keymap.set('t', '<C-y>', '<esc>:undo<Cr>a')

--Save
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a')
vim.keymap.set('n', '<C-s>', ':w<CR>')

--Select text
vim.keymap.set('n', '<S-Right>','vl')
vim.keymap.set('n', '<S-Left>', 'vh')
vim.keymap.set('n', '<S-Up>', 'vk')
vim.keymap.set('n', '<S-Down>', 'vj')
vim.keymap.set('i', '<S-Right','<Esc>vl')
vim.keymap.set('i', '<S-Left>', '<Esc>vh')
vim.keymap.set('i', '<S-Up>', '<Esc>vk')
vim.keymap.set('i', '<S-Down>', '<Esc>vj')
vim.keymap.set('v', '<S-Right','l')
vim.keymap.set('v', '<S-Left>', 'h')
vim.keymap.set('v', '<S-Up>', 'k')
vim.keymap.set('v', '<S-Down>', 'j')
vim.keymap.set('v', '<Up>','<Esc>k')
vim.keymap.set('v', '<Down>', '<Esc>j')
vim.keymap.set('v', '<Left>', '<Esc>h')
vim.keymap.set('v', '<Right>', '<Esc>l')
vim.keymap.set('t', '<S-Right','<Esc>vl')
vim.keymap.set('t', '<S-Left>', '<Esc>vh')
vim.keymap.set('t', '<S-Up>', '<Esc>vk')
vim.keymap.set('t', '<S-Down>', '<Esc>vj')

-- Select text like VSCode does
vim.keymap.del('n', '<C-L>')
vim.keymap.set('i', '<C-l>', '<ESC>0vj')
vim.keymap.set('v', '<C-l>', '$j')
vim.keymap.set('n', '<C-l>', '0vj')

-- Comment
vim.keymap.set('n', '<C-_>', ':Commentary<CR>',{noremap = true, silent = true})
vim.keymap.set('i', '<C-_>', '<ESC>:Commentary<CR>a',{noremap = true, silent = true})
vim.keymap.set('v', '<C-_>', ':Commentary<CR>',{noremap = true, silent = true})

-- ESCAPE
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])

-- Terminal
vim.keymap.set('i', '<C-f>', '<ESC>:ToggleTerm size=10 direction=horizontal<cr>a',{noremap = true, silent = true})
vim.keymap.set('n', '<C-f>', ':ToggleTerm size=10 direction=horizontal<cr>a',{noremap = true, silent = true})
vim.keymap.set('t', '<C-f>', '<C-\\><C-n>:ToggleTerm size=10 direction=horizontal<cr>',{noremap = true, silent = true})

--Open diff view 
vim.keymap.set({'n','i','v'}, '<C-r>', '<ESC>:DiffviewOpen<CR>',{noremap = true, silent = true})
vim.keymap.set({'n','i','v'}, '<C-q>', '<ESC>:DiffviewClose<CR>',{noremap = true, silent = true})
vim.keymap.set({'n','i','v'}, '<C-q>', '<ESC>:DiffviewClose<CR>',{noremap = true, silent = true})

-- Remove highlight
vim.keymap.set({'n','i','v'}, '<leader>h', '<ESC>:nohl<CR>',{noremap = true, silent = true})

--Telescope
vim.keymap.set({'n','i','v'}, '<leader>f', '<ESC>:Telescope grep_string<CR>',{noremap = true, silent = true})
vim.keymap.set('n', '<C-p>', ':Telescope find_files<cr>',{noremap = true, silent = true})

--Git signs
vim.keymap.set({'n','i','v'}, '<leader>g', '<ESC>:Gitsigns blame_line<CR>',{noremap = true, silent = true})

-- NivmTree
vim.keymap.set({'n','i','v'}, '<leader>e', '<ESC>:NvimTreeToggle<CR>',{noremap = true, silent = true})
