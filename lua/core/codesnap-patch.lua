--- Overrides codesnap.module without editing the plugin tree (mistricky/codesnap.nvim#162).
local M = {}

local FIXED_MODULE = [[local module = {}

local path_utils = require("codesnap.utils.path")
local fetch = require("codesnap.fetch")
local platform = require("codesnap.utils.platform")

local OS_LIB_EXTENSION_MAP = {
  mac = "dylib",
  osx = "dylib",
  windows = "dll",
  linux = "so",
}

local sep = path_utils.get_separator()
local RUST_BUILD_DIR = path_utils.with_dir_name(
  ".." .. sep .. ".." .. sep .. ".." .. sep .. "generator" .. sep .. "target" .. sep .. "debug"
)

function module.get_lib_extension()
  local extension = OS_LIB_EXTENSION_MAP[jit.os:lower()]

  return extension or "so"
end

-- Get the path of the the generator file
function module.generator_file_path(is_debug)
  if is_debug then
    local filename = platform.is_windows() and "generator" or "libgenerator"

    return path_utils.join(sep, RUST_BUILD_DIR, filename .. "." .. module.get_lib_extension())
  end

  -- First try to use pre-built library from libs directory
  local ok, lib_path = pcall(fetch.ensure_lib)

  if ok and lib_path and vim.fn.filereadable(lib_path) == 1 then
    return lib_path
  end

  error("Failed to load the generator library. Please ensure it is built correctly.")
end

function module.load_generator(is_debug)
  if module.generator ~= nil then
    return module.generator
  end

  local generator_path = module.generator_file_path(is_debug)
  local loader, err = package.loadlib(generator_path, "luaopen_generator")
  if not loader then
    error("Failed to load generator library: " .. (err or "unknown error"), 0)
  end

  module.generator = loader()
  return module.generator
end

return module
]]

function M.register_preload()
    if package.preload["codesnap.module"] then
        return
    end

    package.preload["codesnap.module"] = function()
        local chunk, err = load(FIXED_MODULE, "codesnap.module", "t")
        if not chunk then
            error(err)
        end
        return chunk()
    end
end

--- Re-download native lib when the plugin version changes.
function M.refresh_lib(plugin_dir)
    local version_file = plugin_dir .. "/lua/libs/.version"
    local project_toml = plugin_dir .. "/project.toml"
    if vim.fn.filereadable(project_toml) ~= 1 then
        return
    end

    local project = table.concat(vim.fn.readfile(project_toml), "\n")
    local want = project:match('version%s*=%s*"([^"]+)"')
    local have = vim.fn.filereadable(version_file) == 1 and vim.fn.readfile(version_file)[1]
    if want and have ~= want then
        local libs = plugin_dir .. "/lua/libs"
        for _, name in ipairs(vim.fn.glob(libs .. "/*_generator.*", false, true)) do
            pcall(vim.fn.delete, name)
        end
        pcall(vim.fn.delete, version_file)
    end
end

return M
