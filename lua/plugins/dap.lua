local dap = require('dap')

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/home/rudy/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
  options = {
    detached = false
  }
}

dap.configurations.cpp = dap.configurations.cpp or {}

local function load_vscode_launch_json()
  local launch_file = vim.fn.getcwd() .. '/.vscode/launch.json'

  if vim.fn.filereadable(launch_file) == 0 then
    return
  end
  local file_content = vim.fn.readfile(launch_file)
  local json_data = vim.fn.json_decode(table.concat(file_content, "\n"))

  if not json_data or not json_data.configurations then
    print("Invalid launch.json format!")
    return
  end

  -- Iterate over configurations and map them to `nvim-dap` format
  for _, config in ipairs(json_data.configurations) do
    if config.type == "cppdbg" then
      table.insert(dap.configurations.cpp, {
        name = "(gdb) Launch",
        type = "cppdbg",
        request = "launch",
        program = "${workspaceFolder}/build/main",
        args = {},
        cwd =  "${workspaceFolder}",
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
    end
  end
end

-- load_vscode_launch_json()
table.insert(dap.configurations.cpp, {
  name = "(gdb) Launch",
  type = "cppdbg",
  request = "launch",
  program = "${workspaceFolder}/build/main",
  args = {},
  cwd =  "${fileDirname}",
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
