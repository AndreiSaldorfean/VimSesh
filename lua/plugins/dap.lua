local dap = require('dap')

dap.adapters.coreclr = {
    type = 'executable',
    command = '/home/rudy/tools/netcoredbg/netcoredbg',
    args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "Launch - netcoredbg",
        request = "launch",
        program = function()
            local dirname = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return vim.fn.getcwd() .. '/bin/Debug/net9.0/' .. dirname .. '.dll'
        end,
    },
}
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = '/home/rudy/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
    options = {
        detached = false
    }
}

dap.configurations.cpp = dap.configurations.cpp or {}

-- load_vscode_launch_json()
table.insert(dap.configurations.cpp, {
    name = "(gdb) Launch",
    type = "cppdbg",
    request = "launch",
    program = "${workspaceFolder}/build/main",
    args = {},
    cwd = "${fileDirname}",
    stopAtEntry = false,
    environment = {},
    externalConsole = false,
    MIMode = "gdb",
    miDebuggerPath = "/usr/bin/gdb",
    setupCommands = {
        {
            description = "Enable pretty printing",
            text = "-enable-pretty-printing",
            ignoreFailures = false,
        }
    }
})
ConfigSet = 0
function Start_default_debugger()
    if ConfigSet == 1 then
        ConfigSet = 0
        dap.continue()
        return
    end
    for _, config in ipairs(dap.configurations.cpp) do
        if config.name == "(gdb) Launch" and ConfigSet == 0 then
            ConfigSet = 1
            dap.run(config)
            return
        end
    end
    print('Default configuration "(gdb) Launch" not found!')
end

dap.configurations.c = dap.configurations.cpp
