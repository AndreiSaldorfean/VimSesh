-- Bootstrap lazy.nvim
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
  -- Debugger
  {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    dependencies = {"williamboman/mason.nvim", "jay-babu/mason-nvim-dap.nvim"},
    config = function()
      require("dapui").setup {}
      require('mason-nvim-dap').setup({
        ensure_installed = { 'cpptools' },
      })
    end
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
  -- Word matching
  {
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure({
        providers = {
          'treesitter',
          'lsp',
          'regex',
        },
        filetypes_denylist = { 'Neotree', 'Lazy', 'alpha' }, -- Exclude certain filetypes
      })
    end
  },
  -- Folding
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      -- Setup ufo with default configuration
      require('ufo').setup({
        open_fold_hl_timeout = 0, -- Disables opening folds automatically
        provider_selector = function(filetype)
          if filetype == 'c' or filetype == 'cpp' then
            return { 'lsp', 'indent' }
          else
            return { 'treesitter', 'indent' }
          end
        end
      })
    end
  },
  -- Dashboard
  {
    "goolord/alpha-nvim",
    config = function()
      require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
    end,
    event = "VimEnter",
  },
  -- Backline
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    -- @module "ibl"
    -- @type ibl.config
    opts = {},
    config = function()
      require("ibl").setup {
        indent = {
          smart_indent_cap = false,
          repeat_linebreak = false
        }
      }
    end
  },
  -- Git when you forget all commands
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = function ()
      require("neogit").setup{}
    end
  },
  -- Used for linters
  {
    'jose-elias-alvarez/null-ls.nvim'
  },
  -- Remember last session
  {
    "olimorris/persisted.nvim",
    lazy = false, -- make sure the plugin is always loaded at startup
    config = true
  },
  -- Vim fugitive, used for seeing files and folders ignored by gitignore
  {
    'tpope/vim-fugitive'
  },
  -- Tree-sitter for syntax highlighting and parsing
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    run = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        prefer_git = false,
        auto_install = false,
        compiler = "gcc",
        ensure_installed = { "c", "python", "cpp", "lua", "markdown", "markdown_inline", "html" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },
  -- Markdown support
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended

    dependencies = {
      "nvim-tree/nvim-web-devicons"
    }
  },
  -- Diff view
  {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('diffview').setup {}
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
    "onsails/lspkind.nvim", -- modifying autocomplete menu
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path'
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
    "catppuccin/nvim",
    "rose-pine/neovim",
    name = "rose-pine",
    'kvrohit/rasmus.nvim',           --  No 2
    "scottmckendry/cyberdream.nvim", -- No 1
    'ribru17/bamboo.nvim',           -- Nice
    lazy = false,
    priority = 1000,
    config = function()
      require('rose-pine').load()
      require('bamboo').load()
    end,
  },
  -- BARBAR
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = '^1.0.0'
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },

    'nvim-telescope/telescope-fzf-native.nvim',
    'junegunn/fzf',
    run = 'make',
  },
  -- TERMINAL
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        shell = "C:\\Tools\\PowerShell\\pwsh.exe"
      })
    end
  },
})
