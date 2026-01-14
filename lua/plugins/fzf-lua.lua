-- Trouble
local config = require("fzf-lua.config")
local actions = require("trouble.sources.fzf").actions

config.defaults.actions.files["ctrl-t"] = actions.open

require("fzf-lua").setup({
    files =
    {
        formatter = "path.filename_first",
    },
    grep =
    {
          -- Use a custom formatter to group by file
          formatter = "path.filename_first",
          file_icons = true,
          git_icons = true,
          color_icons = true,
    },
    fzf_opts = {
        ['--tiebreak'] = 'end'
    },
    winopts =
    {
        fullscreen = true,
        border = "single",
        preview = {
              default        = 'builtin',       -- override the default previewer?
                                                -- default uses the 'builtin' previewer
              border         = "rounded",       -- preview border: accepts both `nvim_open_win`
                                                -- and fzf values (e.g. "border-top", "none")
                                                -- native fzf previewers (bat/cat/git/etc)
                                                -- can also be set to `fun(winopts, metadata)`
              wrap           = false,           -- preview line wrap (fzf's 'wrap|nowrap')
              hidden         = false,           -- start preview hidden
              vertical       = "down:60%",      -- up|down:size
              horizontal     = "right:40%",     -- right|left:size
              layout         = "flex",          -- horizontal|vertical|flex
              flip_columns   = 100,             -- #cols to switch to horizontal on flex
              -- Only used with the builtin previewer:
              title          = true,            -- preview border title (file/buf)?
              title_pos      = "center",        -- left|center|right, title alignment
              scrollbar      = "float",         -- `false` or string:'float|border'
                                                -- float:  in-window floating border
                                                -- border: in-border "block" marker
              scrolloff      = -1,              -- float scrollbar offset from right
                                                -- applies only when scrollbar = 'float'
              delay          = 20,              -- delay(ms) displaying the preview
                                                -- prevents lag on fast scrolling
              winopts = {                       -- builtin previewer window options
                number            = true,
                relativenumber    = false,
                cursorline        = true,
                cursorlineopt     = "both",
                cursorcolumn      = false,
                signcolumn        = "no",
                list              = true,
                foldenable        = true,
                foldmethod        = "manual",
              },
            },
    }
})
