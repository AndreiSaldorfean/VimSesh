require('nvim-tree').setup {
    -- Enable git integration
    git = {
        enable = true,
        ignore = true,
    },
    -- Custom renderer for highlighting git ignored files
    renderer = {
        highlight_git = true,
        highlight_opened_files = "all",
        special_files = {},
        icons = {
            glyphs = {
                default = '',
                symlink = '',
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = ""
                },
            },
            show = {
              git = true
            }
        },
    },
}
require("nvim-tree.api").tree.open()
require("nvim-tree.api").tree.toggle_gitignore_filter()
