-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup {}
    end,
  },
})
-- C/C++ LSP
local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
  cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
  init_options = {
    fallback_flags = { '-std=c++17' },
  }
}

local cmp = require('cmp')
local lspkind = require('lspkind')

-- LuaSnip configuration (for snippet support)
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()  -- Load snippets from friendly-snippets or VSCode format

cmp.setup({
  enabled = function()
    -- disable completion in comments
    local context = require 'cmp.config.context'
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
    end
  end,
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'luasnip'},
    { name = 'path' },
    { name = 'buffer' },
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)  -- Use LuaSnip for snippet expansion
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-e>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-\\><C-n><C-\\><C-n>'] = cmp.mapping.abort(),
    ['<TAB>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<S-TAB>'] = function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 30, -- if you want to not show text
      symbol_map = {
        Text = "T",
        Method = "m",
        Function = "F",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "v",
        Enum = "",
        Keyword = "k",
        Snippet = "",
        Color = "c",
        File = "f",
        Reference = "",
        Folder = ">",
        EnumMember = "",
        Constant = "C",
        Struct = "",
        Event = "",
        Operator = "O",
        TypeParameter = "tp",
      },
      menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        path = "[Path]",
        luasnip = "[Snippet]",
        cmdline = "[Cmdline]",
      })
    }),
  },
  window = {
    completion = cmp.config.window.bordered(), -- Border around the menu
    documentation = cmp.config.window.bordered(),
  },
})

