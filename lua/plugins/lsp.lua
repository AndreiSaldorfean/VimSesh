local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
  local opts = {buffer = bufnr}
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup{}
    end,
  },
})
-- C/C++ LSP
local lspconfig = require('lspconfig')
lspconfig.ccls.setup{
   cmd = { "ccls" },
   filetypes = { "c", "cpp", "objc", "objcpp" },
   root_dir = lspconfig.util.root_pattern(".ccls", "compile_commands.json"),
}
local null_ls = require("null-ls")
local b = null_ls.builtins

null_ls.setup({
    sources = {
        -- Using cppcheck for MISRA-C compliance
        b.diagnostics.cppcheck.with({
            extra_args = {
                "--enable=all",                      -- Enable all checks
                "--inconclusive",                    -- Include inconclusive checks
                "--std=c++11",                         -- Specify C standard
                "--language=c++",                      -- Specify language
                "--addon=misra",                     -- Enable MISRA addon
                "--suppress=missingIncludeSystem"    -- Suppress missing include errors
            },
            filetypes = {"c","cpp"},
        }),
    },
})

local cmp = require('cmp')

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
  sources = cmp.config.sources{
    {name = 'nvim_lsp'},
    {name = 'buffer'},
    {name =  'path'}
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
       vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
      ['<C-e>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-\\><C-n><C-\\><C-n>'] = cmp.mapping.abort(),
      ['<TAB>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
      -- set a name for each source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end,
  },
})
