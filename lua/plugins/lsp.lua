vim.lsp.enable('clangd')
vim.lsp.enable('pylsp')
vim.lsp.enable('lua_ls')

-- C/C++ LSP
vim.lsp.config.clangd = {
    name = "clangd",
    cmd = { 'clangd', '--background-index', '--clang-tidy', '--completion-style=detailed', '--fallback-style=llvm' },
    on_attach = function(client, bufnr)
        if client.server_capabilities.semantictokensprovider then
            vim.lsp.semantic_tokens.start(bufnr, client.id)
        end
    end,
    init_options = {
        fallback_flags = { '-std=c++17' },
    }
}

-- Python LSP
vim.lsp.config.pylsp = {
    name = "pylsp",
    cmd = { 'pylsp' },
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {'W391'},
                    maxLineLength = 100
                },
                pyflakes = { enabled = true },
                pylint = { enabled = false },
                yapf = { enabled = true },
                autopep8 = { enabled = false },
                black = { enabled = true },
                isort = { enabled = true },
                mypy = { enabled = true },
            }
        }
    }
}

-- Lua LSP
vim.lsp.config.lua_ls = {
    name = "lua_ls",
    cmd = { 'lua-language-server' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = {'vim'},
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}

-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
    require('lspconfig')[ls].setup({
        capabilities = capabilities
        -- you can add other fields for setting up lsp server in this table
    })
end
require('ufo').setup()
