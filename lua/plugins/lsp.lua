vim.lsp.enable('clangd')
vim.lsp.enable('pylsp')
vim.lsp.enable('lua_ls')
vim.lsp.enable('neocmake')

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

-- CMake LSP (neocmakelsp uses 'stdio' as a subcommand)
vim.lsp.config.neocmake = {
    name = "neocmake",
    cmd = { 'neocmakelsp', 'stdio' },
    filetypes = { 'cmake' },
    root_markers = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' },
}

-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

-- Auto-configure all Mason-installed LSPs
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
    mason.setup()
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")

if mason_lspconfig_ok then
    -- Setup mason-lspconfig
    mason_lspconfig.setup({
        ensure_installed = {
            "clangd",
            "pylsp",
            "lua_ls",
        },
        automatic_installation = true,
    })

    -- Get list of installed servers from mason-lspconfig
    local installed_servers = mason_lspconfig.get_installed_servers()

    -- Servers that are manually configured via vim.lsp.config above
    local manual_servers = { "clangd", "pylsp", "lua_ls", "neocmake" }

    -- Auto-setup all installed servers except the manually configured ones
    for _, server_name in ipairs(installed_servers) do
        local is_manual = false
        for _, manual in ipairs(manual_servers) do
            if server_name == manual then
                is_manual = true
                break
            end
        end

        if not is_manual then
            -- Simply enable the LSP using vim.lsp.enable (new API)
            -- vim.lsp.enable will use sensible defaults automatically
            vim.lsp.enable(server_name)
        end
    end
end

require('ufo').setup()
