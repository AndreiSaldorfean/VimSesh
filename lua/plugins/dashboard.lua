local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')
local icons = require("core.icons")

dashboard.section.header.val = {
"██╗   ██╗██╗███╗   ███╗███████╗███████╗███████╗██╗  ██╗",
"██║   ██║██║████╗ ████║██╔════╝██╔════╝██╔════╝██║  ██║",
"██║   ██║██║██╔████╔██║███████╗█████╗  ███████╗███████║",
"╚██╗ ██╔╝██║██║╚██╔╝██║╚════██║██╔══╝  ╚════██║██╔══██║",
" ╚████╔╝ ██║██║ ╚═╝ ██║███████║███████╗███████║██║  ██║",
"  ╚═══╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝"
}

dashboard.section.buttons.val = {
    dashboard.button( "s", icons.ui.ArrowCircleDown .. "  Restore Session", "<CMD>:lua require('persisted').load()<CR>"),
    dashboard.button( "f", icons.ui.FindFile .. "  Find File", "<CMD>Telescope find_files<CR>" ),
    dashboard.button("n", icons.ui.NewFile .. "  New File", "<CMD>ene!<CR>"),
    dashboard.button("p", icons.ui.Project .. "  Projects ", "<CMD>Telescope projects<CR>"),
    dashboard.button("r", icons.ui.History .. "  Recent files", ":Telescope oldfiles <CR>" ),
    dashboard.button("t", icons.ui.FindText .. "  Find Text", "<CMD>Telescope live_grep<CR>"),
    dashboard.button("q", icons.ui.Close .. "  Quit", "<CMD>quit<CR>"),
}
-- Footer (optional)
dashboard.section.footer.val = "Neovim loaded successfully!"
alpha.setup(dashboard.config)

