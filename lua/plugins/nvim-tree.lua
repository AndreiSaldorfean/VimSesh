require("nvim-tree").setup({
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
    git = {
      enable = true
    },
    
  })
require("nvim-tree.api").tree.open()
-- Highlight git ignored files in gray
vim.cmd [[
  highlight NvimTreeGitIgnored guifg=#6C6C6C
]]

vim.api.nvim_set_hl(0, "NvimTreeGitIgnored", { fg = "#6C6C6C" })
