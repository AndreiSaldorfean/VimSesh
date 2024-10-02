vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("Neotree close")
  end,
})
