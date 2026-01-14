local harpoon = require("harpoon")

harpoon:setup({
    default = {
        display = function(list_item)
            local path = list_item.value
            local filename = vim.fn.fnamemodify(path, ":t")
            if filename == "" then
                return path
            end
            return filename .. ": " .. path
        end,
    },
    -- Setting up custom behavior for a list named "cmd"
    menu = {
        width = 10
    },
    settings = {
        save_on_toggle = false,
        sync_on_ui_close = false,
        key = function()
            return vim.loop.cwd()
        end,
    },
})

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>q", function() harpoon.ui:toggle_quick_menu(harpoon:list(), { ui_width_ratio = 0.8 }) end)
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)


-- Add syntax highlighting for the harpoon menu
vim.api.nvim_create_autocmd("FileType", {
    pattern = "harpoon",
    callback = function()
        vim.cmd([[syntax match HarpoonFilename /^[^:]*/ ]])
        vim.cmd([[syntax match HarpoonPath /:\s*.*$/ ]])
    end,
})

-- Set colors for the highlight groups
vim.api.nvim_set_hl(0, "HarpoonFilename", { fg = "#61afef", bold = true })  -- Blue filename
vim.api.nvim_set_hl(0, "HarpoonPath", { fg = "#5c6370" })  -- Gray path
