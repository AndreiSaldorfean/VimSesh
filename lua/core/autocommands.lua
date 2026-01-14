
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local start_time = vim.fn.reltime()
        vim.schedule(function()
            local elapsed_time = vim.fn.reltimefloat(vim.fn.reltime(start_time)) * 1000
            print(string.format("Buffer loaded in %.0f ms", elapsed_time))
        end)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "asm",
    callback = function()
        if vim.fn.expand("%:e") == "asm" then
            vim.cmd("setlocal syntax=masm")
        end
    end,
})
