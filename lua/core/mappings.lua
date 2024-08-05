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

-- Navigation
function CustomLeft()
    print("Normal_Left")
    local col = vim.fn.col('.')
      if col == 1 then
        vim.api.nvim_command('normal! k$l')
    else
        vim.api.nvim_command('normal! h')
    end
end

function CustomRight()
    local col = vim.fn.col('.')
    local line_length = vim.fn.col('$')-1
    if col == line_length then
        -- If at the end of the line, move to the start of the next line
        vim.api.nvim_command('normal! j0')
    elseif line_length == 0 then
        -- If not at the end, move one character to the right
        vim.api.nvim_command('normal! j0')
    else
      vim.api.nvim_command('normal! l')
    end
end

function CustomLeft_Insert()
    local col = vim.fn.col('.')
    local line_length = vim.fn.col('$')-1
    if col == 1 and line_length == 0 then
        inserKeyLeft = 0
        vim.api.nvim_command('normal! k$')
    elseif inserKeyLeft == 2 then
        inserKeyLeft = 0
        vim.api.nvim_command('normal! k$')
   end
   if col == 1 then
      inserKeyLeft = inserKeyLeft + 1
   end
    vim.api.nvim_command('startinsert')
end

function CustomRight_Insert()
    local col = vim.fn.col('.')
    local line_length = vim.fn.col('$') - 1
    if col == line_length then
        vim.api.nvim_command('normal! j0')
    elseif 0 == line_length then
        vim.api.nvim_command('normal! j0')
    else
        vim.api.nvim_command('normal! l')
    end
    vim.api.nvim_input('a')
end

vim.keymap.set('n', '<Left>', '<ESC>:lua CustomLeft()<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<Left>', '<ESC>:lua CustomLeft_Insert()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Right>', '<ESC>:lua CustomRight()<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<Right>', '<ESC>:lua CustomRight_Insert()<CR>', { noremap = true, silent = true })

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
vim.keymap.set('n', '<C-f>', ':ToggleTerm size=10 direction=horizontal<cr>')

-- Find file like Vscode
vim.keymap.set('n', '<C-p>', ':Telescope find_files<cr>')

--Open diff view 
vim.keymap.set({'n','i','v'}, '<C-r>', '<ESC>:DiffviewOpen<CR>')
vim.keymap.set({'n','i','v'}, '<C-q>', '<ESC>:DiffviewClose<CR>')
vim.keymap.set({'n','i','v'}, '<C-q>', '<ESC>:DiffviewClose<CR>')

vim.cmd [[let &shell = '"C:\Program Files\Git\bin\bash.exe']]
vim.cmd [[let &shellcmdflag = '-s']]
