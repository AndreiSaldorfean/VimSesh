vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        vim.cmd("Neotree close")
    end,
})
require('core.plugins')
require('core.options')
require('core.mappings')
