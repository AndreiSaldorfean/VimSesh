vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("Neotree close")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local start_time = vim.fn.reltime()
        vim.schedule(function()
            local elapsed_time = vim.fn.reltimefloat(vim.fn.reltime(start_time)) * 1000
            print(string.format("Buffer loaded in %.0f ms", elapsed_time))
        end)
    end,
})
