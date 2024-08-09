local inserKeyLeft = 0
-- Copy
vim.keymap.set('i', '<C-c>', '<Esc>yy<CR>')
vim.keymap.set('n', '<C-c>', 'yy')
vim.keymap.set('v', '<C-c>', 'ygv')

-- Paste
vim.keymap.set('i', '<C-v>', '<ESC>pa')
vim.keymap.set('n', '<C-v>', 'p')
vim.keymap.set('v', '<C-v>', 'p')
-- Undo
vim.keymap.set('i', '<C-z>', '<Esc>ua')
vim.keymap.set('n', '<C-z>', 'u')

--Redo
vim.keymap.set('n', '<C-y>', ':undo<Cr>')
vim.keymap.set('i', '<C-y>', ':undo<Cr>a')

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

-- Select text like VSCode does
vim.keymap.del('n', '<C-L>')
vim.keymap.set('i', '<C-l>', '<ESC>0vj')
vim.keymap.set('v', '<C-l>', '$j')
vim.keymap.set('n', '<C-l>', '0vj')

-- Comment
vim.keymap.set('n', '<C-_>', ':Commentary<CR>')
vim.keymap.set('i', '<C-_>', '<ESC>:Commentary<CR>a')
vim.keymap.set('v', '<C-_>', ':Commentary<CR>')

-- ESCAPE
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])

-- Terminal
vim.keymap.set('i', '<C-f>', '<ESC>:ToggleTerm size=10 direction=horizontal<cr>a',{noremap = true, silent = true})
vim.keymap.set('n', '<C-f>', ':ToggleTerm size=10 direction=horizontal<cr>a',{noremap = true, silent = true})
vim.keymap.set('t', '<C-f>', '<C-\\><C-n>:ToggleTerm size=10 direction=horizontal<cr>',{noremap = true, silent = true})

-- Find file like Vscode
vim.keymap.set('n', '<C-p>', ':Telescope find_files<cr>')

--Open diff view 
vim.keymap.set({'n','i','v'}, '<C-r>', '<ESC>:DiffviewOpen<CR>')
vim.keymap.set({'n','i','v'}, '<C-q>', '<ESC>:DiffviewClose<CR>')
vim.keymap.set({'n','i','v'}, '<C-q>', '<ESC>:DiffviewClose<CR>')
