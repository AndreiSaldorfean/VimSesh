vim.lsp.enable('clangd')

-- C/C++ LSP
vim.lsp.config.clangd = {
    name = "clangd",
    cmd = { 'clangd', '--background-index', '--clang-tidy', '--completion-style=detailed', '--fallback-style=llvm' },
    on_attach = function(client, bufnr)
        if client.server_capabilities.semanticTokensProvider then
            vim.lsp.semantic_tokens.start(bufnr, client.id)
        end
    end,
    init_options = {
        fallback_flags = { '-std=c++17' },
    }
}
