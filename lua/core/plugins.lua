-- Bootstrap lazy.nvimplugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
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
    "folke/neodev.nvim",
    opts = {},
    config = function()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end
  },
  -- Debugger
  {
    "mfussenegger/nvim-dap",
    dependencies = { "williamboman/mason.nvim", "jay-babu/mason-nvim-dap.nvim" },
    config = function()
      require("dapui").setup {}
      require('mason-nvim-dap').setup({
        ensure_installed = { 'cpptools' },
      })
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  -- Faster motions
  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
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
          smart_indent_cap = false,
          repeat_linebreak = false,
        }
      }
    end
  },
  -- Remember last session
  {
    "olimorris/persisted.nvim",
    lazy = false, -- make sure the plugin is always loaded at startup
    config = true
  },
  -- Tree-sitter for syntax highlighting and parsing
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate', -- Ensure treesitter is installed and updated
    config = function()
      require('nvim-treesitter.configs').setup {
        -- Treesitter configs
        ensure_installed = { "cpp", "c", "lua", "python", "javascript" }, -- Add the languages you need
        highlight = {
          enable = true,                                                  -- false will disable the whole extension
        },
      }
    end
  },
  -- AUTO PAIRS
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },
  -- Comments
  {
    "tpope/vim-commentary",
    event = "VeryLazy",
  },
  -- GITSIGNS
  {
    "lewis6991/gitsigns.nvim"
  },
  -- LSP
  {
    "onsails/lspkind.nvim",
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path'
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
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
          },                                      -- Automatically select the file in the tree
          hijack_netrw_behavior = "open_default", -- This ensures it hijacks netrw
          use_libuv_file_watcher = true,          -- This helps with automatically updating the tree
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
  -- STATUS BAR
  {
    "famiu/feline.nvim"
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
  -- BARBAR
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function() vim.g.barbar_auto_setup = true end,
    version = '^1.0.0'
  },
  -- TERMINAL
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup {}
    end
  },
})
