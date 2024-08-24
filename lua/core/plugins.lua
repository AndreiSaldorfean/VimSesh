-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
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
      "mg979/vim-visual-multi"
    },
    {
      "Pocco81/auto-save.nvim",
      config = function()
         require("auto-save").setup {
          -- your config goes here
          -- or just leave it empty :)
         }
      end,
    },
    {
      'p00f/nvim-ts-rainbow',
      config = function()

	require('nvim-ts-rainbow').setup {
	  -- configuration options
	  -- for example, you can specify colors for brackets
	  colors = {
	     "#ff5ea0",  -- Red
            "#ffbd5e",  -- Yellow
            "#bd80ff",  -- Purple
	  },
	  -- additional options
	}
end
    },
    -- Dashboard
    {
      'goolord/alpha-nvim',
      config = function ()
          require'alpha'.setup(require'alpha.themes.dashboard'.config)
      end
      },
    -- Used for linters
    {
      'jose-elias-alvarez/null-ls.nvim'
    },
    -- Improved git support
    {
        "NeogitOrg/neogit",
      dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        "sindrets/diffview.nvim",        -- optional - Diff integration

        -- Only one of these is needed, not both.
        "nvim-telescope/telescope.nvim", -- optional
        "ibhagwan/fzf-lua",              -- optional
      },
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
          compilers = {"clang"},
          auto_install = false,
          ensure_installed = { "c", "python", "cpp", "lua","markdown","markdown_inline","html"}, -- Add other parsers as needed
          highlight = {
            enable = true,  -- Enable Tree-sitter based highlighting
            additional_vim_regex_highlighting = false,  -- Disable Vim regex based highlighting
          },
          -- rainbow = {
          --  enable = true,
          --   extended_mode = true,
          --   max_file_lines = nil,
          --   colors = {
          --     "#ff5ea0",  -- Red
          --     "#ffbd5e",  -- Yellow
          --     "#bd80ff",  -- Purple
          --   }
          -- }
         }
      end,
    },
    -- Markdown
    {
        "OXY2DEV/markview.nvim",
        lazy = false,      -- Recommended

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
    --Comments
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
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
        'VonHeikemen/lsp-zero.nvim', branch = 'v4.x',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path'
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      },
      config = function ()
        require("neo-tree").setup({
          filesystem = {
              filtered_items={
                hide_dotfiles = false,
                hide_gitignored = false,
              },
              hide_by_name = {
                  --"node_modules"
              },
              always_show = {".gitignore"}
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
        "rose-pine/neovim", name = "rose-pine",
        'kvrohit/rasmus.nvim', --  No 2
        "scottmckendry/cyberdream.nvim", -- No 1
        'ribru17/bamboo.nvim', -- Nice
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
            'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        init = function() vim.g.barbar_auto_setup = false end,
        opts = {
            -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
            -- animation = true,
            -- insert_at_start = true,
            -- …etc.
        },
        version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    -- TELESCOPE
    {
      'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- TERMINAL
    {
        'akinsho/toggleterm.nvim', version = "*", config = true
    },
  })
