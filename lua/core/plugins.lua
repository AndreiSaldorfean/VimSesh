-- Bootstrap lazy.nvimplugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
a           { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require("lazy").setup({
    {
        "ThePrimeagen/harpoon",
        config = function()
            require("harpoon").setup {
                global_settings = {
                    -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
                    save_on_toggle = true,

                    -- saves the harpoon file upon every change. disabling is unrecommended.
                    save_on_change = true,

                    -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
                    enter_on_sendcmd = false,

                    -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
                    tmux_autoclose_windows = false,

                    -- filetypes that you want to prevent from adding to the harpoon list menu.
                    excluded_filetypes = { "harpoon" },

                    -- set marks specific to each git branch inside git repository
                    mark_branch = false,

                    -- enable tabline with harpoon marks
                    tabline = false,
                    tabline_prefix = " ",
                    tabline_suffix = " ",
                }
            }
        end
    },
    {
        "mg979/vim-visual-multi"
    },
    {
        "godlygeek/tabular",
        cmd = {"Tabularize"}
    },
    -- Switch between source and header c/c++
    {
        'nvim-lua/plenary.nvim',
        'jakemason/ouroboros'
    },
    -- Code folding
    {
        'kevinhwang91/nvim-ufo',
    },
    {
        'kevinhwang91/promise-async'
    },
    -- Lazy.nvim
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup {
                shell = vim.o.shell,
                direction = "float",
                float_opts = {
                    border = "curved",
                    width = math.floor(vim.o.columns * 0.9),
                    height = math.floor(vim.o.lines * 0.85),
                }
            }
        end
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader><leader>",
                -- "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        'johnfrankmorgan/whitespace.nvim',
        config = function()
            require('whitespace-nvim').setup({
                highlight = 'DiffDelete',
                ignored_filetypes = { 'blink-cmp-menu', 'Typr', 'TyprStats', 'floggraph', 'fzf', 'neo-tree', 'toggleterm', 'TelescopePrompt', 'Trouble', 'help', 'dashboard' },
                ignore_terminal = true,
                return_cursor = true,
            })

            -- remove trailing whitespace with a keybinding
            vim.keymap.set('n', '<Leader>t', require('whitespace-nvim').trim)
        end
    },
    -- Backline
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            require("ibl").setup {
                indent = {
                    char = '│',
                    -- smart_indent_cap = false,
                    -- repeat_linebreak = false,
                },
                scope = { enabled = false }
            }
        end,
    },
    -- Tree-sitter for syntax highlighting and parsing
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate', -- Ensure treesitter is installed and updated
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { "lua", "python", "javascript", "typescript", "html", "css", "json", "yaml", "markdown", "bash", "c", "cpp" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                fold = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            })
        end
    },
    -- AUTO PAIRS
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    -- GITSIGNS
    {
        "lewis6991/gitsigns.nvim"
    },
    {
        'neovim/nvim-lspconfig',
    },
    {
        'saghen/blink.cmp',
        lazy = false, -- lazy loading handled internally
        -- optional: provides snippets for the snippet source
        dependencies = 'rafamadriz/friendly-snippets',

        -- use a release tag to download pre-built binaries
        version = 'v0.*',
        -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- see the "default configuration" section below for full documentation on how to define
            -- your own keymap.
            keymap = {
                preset = 'default',
                ['<C-y>'] = { 'select_and_accept' },
                ['<Tab>'] = { 'accept', 'fallback' },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            -- default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, via `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                -- optionally disable cmdline completions
                -- cmdline = {},
            },

            -- experimental signature help support
            -- signature = { enabled = true }
        },
        -- allows extending the providers array elsewhere in your config
        -- without having to redefine it
        opts_extend = { "sources.default" }
    },
    -- LSP
    {
        'williamboman/mason.nvim',
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
        },
    },
    -- File explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                default_component_configs = {
                    icon = {
                        folder_closed = "", -- Icon for closed folder
                        folder_open = "", -- Icon for open folder
                    },
                },
                filesystem = {
                    follow_current_file = {
                        enabled = true
                    },                            -- Automatically select the file in the tree
                    hijack_netrw_behavior = "open_default", -- This ensures it hijacks netrw
                    use_libuv_file_watcher = true, -- This helps with automatically updating the tree
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                    hide_by_name = {
                        --"node_modules"
                    },
                    always_show = { ".gitignore" }
                }
            })
        end
    },
    -- COLORSCHEME
    {
         'Mofiqul/vscode.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('vscode').load()
        end,
    },
    -- -- BARBAR
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        init = function()
            vim.g.barbar_auto_setup = true
        end,
        version = '^1.0.0'
    }
})
