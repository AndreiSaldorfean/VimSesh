-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
-- local mason_registry = require("mason-registry")

-- Function to ensure cpptools is installed
-- Import Mason API
require('mason').setup({
    ensure_installed = {
        'clangd',
        'cmake',
        'dockerls',
        'gopls',
        'html',
        'jsonls',
    },
})
require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup {}
        end,
    },
})

-- C/C++ LSP
-- local lspconfig = require('lspconfig')
-- lspconfig.clangd.setup {
--     on_attach = function(client, bufnr)
--         if client.server_capabilities.semanticTokensProvider then
--             vim.lsp.semantic_tokens.start(bufnr, client.id)
--         end
--     end,
--     cmd = { 'clangd', '--background-index', '--clang-tidy', '--completion-style=detailed', '--fallback-style=llvm' },
--     init_options = {
--         fallback_flags = { '-std=c++17' },
--     }
-- }
