-- Lua: For dark theme (neovim's default)
vim.o.background = 'dark'

local links = {
  ['@lsp.type.namespace'] = '@namespace',
  ['@lsp.type.type'] = '@type',
  ['@lsp.type.class'] = '@type',
  ['@lsp.type.enum'] = '@type',
  ['@lsp.type.interface'] = '@type',
  ['@lsp.type.struct'] = '@structure',
  ['@lsp.type.parameter'] = '@parameter',
  ['@lsp.type.variable'] = '@variable',
  ['@lsp.type.property'] = '@property',
  ['@lsp.type.enumMember'] = '@constant',
  ['@lsp.type.function'] = '@function',
  ['@lsp.type.method'] = '@method',
  ['@lsp.type.macro'] = '@macro',
  ['@lsp.type.decorator'] = '@function',
}
for newgroup, oldgroup in pairs(links) do
  vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
end

for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = 'X',
            [vim.diagnostic.severity.WARN] = '⚠',
            [vim.diagnostic.severity.INFO] = 'i',
            [vim.diagnostic.severity.HINT] = '?',
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
            [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
        }
    }
})

local c = require('vscode.colors').get_colors()
require('vscode').setup({
  -- Alternatively set style in setup
  -- style = 'light'

  -- Enable transparent background
  transparent = false,

  -- Enable italic comment
  italic_comments = false,

  -- Underline `@markup.link.*` variants
  underline_links = true,

  -- Disable nvim-tree background color
  disable_nvimtree_bg = false,
  -- Override colors (see ./lua/vscode/colors.lua)
  color_overrides = {
    vscGitIgnored = '#4a4a4a',
    vscLineNumber = '#454545',
  },

  -- Override highlight groups (see ./lua/vscode/theme.lua)
  group_overrides = {
    -- this supports the same val table as vim.api.nvim_set_hl
    -- use colors from this colorscheme by requiring vscode.colors!
    Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
  }
  })
-- require('vscode').load()

-- load the theme without affecting devicon colors.
vim.cmd.colorscheme "vscode"

-- vim.api.nvim_create_autocmd("LspTokenUpdate", {
--   callback = function(args)
--     local token = args.data.token
--     if token.type == "variable" and token.modifiers.globalScope and not token.modifiers.readonly then
--       vim.api.nvim_set_hl(0, 'GlobalVarHL', { fg = '#3b9aa3' })
--       vim.lsp.semantic_tokens.highlight_token(token, args.buf, args.data.client_id, 'GlobalVarHL')
--     end
--   end,
-- })

vim.cmd([[
  highlight NeoTreeGitIgnored guifg=#7f8c8c
  highlight NeoTreeGitModified guifg=#e2b968
  highlight NeoTreeGitUntracked guifg=#50b791
]])

vim.cmd([[
    highlight RainbowDelimiterYellow guifg=#f8b417
    highlight RainbowDelimiterBlue guifg=#1895e2
    highlight RainbowDelimiterViolet guifg=#da70d6
]])

vim.api.nvim_set_hl(0, "@keyword.modifier", { fg = '#156ab0' })
vim.api.nvim_set_hl(0, "@keyword.directive", { link = "@function.macro" })
vim.api.nvim_set_hl(0, "@lsp.typemod.class.classScope.cpp", { link = "@function.method" })
vim.api.nvim_set_hl(0, "@string.escape.cpp", { fg = '#d7ba66' })
-- vim.api.nvim_set_hl(0, "@lsp.type.operator.cpp", { fg = '#c586c0' })
vim.api.nvim_set_hl(0, "DiffviewStatusModified", { fg = '#e2b968' })
vim.api.nvim_set_hl(0, "DiffviewFilePanelInsertions", { fg = '#e2b968' })
vim.api.nvim_set_hl(0, "DiffviewFilePanelDeletions", { fg = '#e44b4b' })
vim.api.nvim_set_hl(0, "DiffviewStatusUntracked", { fg = '#50b791' })
vim.api.nvim_set_hl(0, "DiffviewFolderName", { fg = '#d4d4d4' })
vim.api.nvim_set_hl(0, 'Folded', { fg = '#7d97b0'})
vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = '#D787AF'})
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#156ab0'})
vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#454545", bg = "none"})
vim.api.nvim_set_hl(0, "BufferTabpageFill", { fg = "none", bg = "#222222"})
vim.api.nvim_set_hl(0, "BufferTabpageFill", { fg = "none", bg = "#222222"})
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#454545", bg = "none"})
vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { fg = "#454545", bg = "none"})
vim.api.nvim_set_hl(0, "DiffviewDiffDeleteDim", { fg = "#454545", bg = "none"})
vim.api.nvim_set_hl(0, "DiffviewDiffText", { bg = "#095954"})
vim.api.nvim_set_hl(0, "DiffviewDiffChange", { bg = "#133138"})
vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = "#401411"})
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#383838" })
vim.api.nvim_set_hl(0, 'NeoTreeIndentMarker', { fg = '#454545', bg='none'})
vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', { fg = '#ff8800', bg='none' })
vim.api.nvim_set_hl(0, 'LineNr', { fg='#7f848a', bold=true })

vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')

vim.opt.fillchars:append { diff = "╱" }
--vim.api.nvim_set_hl(0, "FlogMergeCommit", { bg = "#401411"})

