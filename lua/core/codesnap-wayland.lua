--- Wayland clipboard workaround for codesnap.nvim (#166).
--- generator.copy() blocks Neovim until wl-copy releases the clipboard pipe.
local M = {}

local function is_wayland()
    return vim.env.WAYLAND_DISPLAY ~= nil or vim.env.XDG_SESSION_TYPE == "wayland"
end

local function read_file(path)
    local f = io.open(path, "rb")
    if not f then
        return nil
    end
    local data = f:read("*a")
    f:close()
    return data
end

--- Save snapshot to a temp file, then copy via async wl-copy (non-blocking).
local function copy_file_to_clipboard(path, mime, on_done)
    local data = read_file(path)
    pcall(vim.fn.delete, path)
    if not data then
        on_done(false, "failed to read snapshot file")
        return
    end

    vim.system({ "wl-copy", "--type", mime }, { stdin = data }, function(obj)
        if on_done then
            vim.schedule(function()
                on_done(obj.code == 0, obj.stderr or "")
            end)
        end
    end)
end

local function copy_snapshot()
    local config = require("codesnap.config").get_config()
    local gen = require("codesnap.module").load_generator()
    local tmp = vim.fn.tempname() .. ".png"

    gen.save(tmp, config)
    vim.cmd("delmarks <>")

    copy_file_to_clipboard(tmp, "image/png", function(ok, err)
        if ok then
            vim.notify("Snapshot copied to clipboard")
        else
            vim.notify("wl-copy failed: " .. vim.trim(err), vim.log.levels.ERROR)
        end
    end)
end

local function override_command(name, fn)
    pcall(vim.api.nvim_del_user_command, name)
    vim.api.nvim_create_user_command(name, function()
        xpcall(fn, function(err)
            vim.notify(tostring(err), vim.log.levels.ERROR)
        end)
    end, { nargs = "*", range = "%" })
end

function M.setup()
    if not is_wayland() then
        return
    end

    if vim.fn.executable("wl-copy") == 0 then
        vim.notify("codesnap: wl-copy not found; clipboard copy may hang on Wayland", vim.log.levels.WARN)
        return
    end

    if vim.fn.executable("wl-clip-persist") == 0 and not vim.g.codesnap_wl_tip then
        vim.g.codesnap_wl_tip = true
        vim.notify(
            "Install wl-clip-persist to keep CodeSnap images on the clipboard after Neovim closes",
            vim.log.levels.INFO
        )
    end

    override_command("CodeSnap", copy_snapshot)
end

return M
