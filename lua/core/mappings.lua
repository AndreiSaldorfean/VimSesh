--- Comment
vim.keymap.set({'n','i'}, '<C-_>', '<esc>:Commentary<CR>',{noremap = true, silent = true})
vim.keymap.set('v', '<C-_>', ':Commentary<CR>',{noremap = true, silent = true})

---- ESCAPE
vim.keymap.set('t', '<esc>', '<C-\\><C-n>',{noremap = true, silent = true})

---- Terminal
vim.keymap.set({'n','t','i'}, '<C-f>', '<C-\\><C-n>:ToggleTerm size=10 direction=horizontal<cr>',{noremap = true, silent = true})

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
vim.keymap.set({'n','v'}, ';', '<ESC>:Neogit<CR>',{noremap = true, silent = true})

vim.keymap.set('n', '<Tab>', '>>',{noremap = true, silent = true})
vim.keymap.set('n', '<S-Tab>', '<<',{noremap = true, silent = true})

-- Function to indent selected text
local function indent_selection()
  vim.cmd('normal! gv')
  vim.cmd('normal! >')
end

-- Map <Tab> to indent and <S-Tab> to unindent in visual mode
vim.api.nvim_set_keymap('v', '<Tab>', [[:lua indent_selection()<CR>gv]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', [[:lua indent_selection()<CR><gv]], { noremap = true, silent = true })

