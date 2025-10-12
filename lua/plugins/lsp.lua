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
