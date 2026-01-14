function RmWhitespaces()
  vim.cmd([[%s/\s\+$//e]])
end

vim.api.nvim_create_user_command('RmWhitespaces', RmWhitespaces, {})
