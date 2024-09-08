local dap = require('dap')

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = 'C:/Users/andre/AppData/Local/nvim-data/mason/bin/OpenDebugAD7.cmd',
  options = {
    detached = false
  }
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
    setupCommands = {
      {
        text = '-enable-pretty-printing',
        description = 'enable pretty printing',
        ignoreFailures = false
      },
    },
    args = {},
    environment = {},
    externalConsole = true,
    MIMode = 'gdb',
    miDebuggerPath = 'C:/msys64/mingw64/bin/gdb.exe', -- Path to gdb
    logging = { moduleLoad = false },
  },
}

dap.configurations.c = dap.configurations.cpp
local dapui = require("dapui")

-- Automatically open dap-ui when dap starts
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

-- Automatically close dap-ui when dap stops
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
