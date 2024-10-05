local dap = require('dap')

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = 'C:/Users/andre/AppData/Local/nvim-data/mason/bin/OpenDebugAD7.cmd',
  options = {
    detached = false
  }
}

dap.configurations.cpp = dap.configurations.cpp or {}

-- Function to load the `.vscode/launch.json` file
local function load_vscode_launch_json()
  -- Define the path to `.vscode/launch.json`
  local launch_file = vim.fn.getcwd() .. '/.vscode/launch.json'

  if vim.fn.filereadable(launch_file) == 0 then
    return
  end
  -- Read the JSON file
  local file_content = vim.fn.readfile(launch_file)

  -- Parse the JSON content
  local json_data = vim.fn.json_decode(table.concat(file_content, "\n"))

  if not json_data or not json_data.configurations then
    print("Invalid launch.json format!")
    return
  end

  -- Iterate over configurations and map them to `nvim-dap` format
  for _, config in ipairs(json_data.configurations) do
    if config.type == "cppdbg" then
      table.insert(dap.configurations.cpp, {
        name = config.name,
        type = "cppdbg",
        request = config.request,
        program = config.program,
        args = config.args or {},
        cwd = config.cwd or "${workspaceFolder}",
        stopAtEntry = config.stopAtEntry or false,
        environment = config.environment or {},
        externalConsole = config.externalConsole or false,
        MIMode = config.MIMode or "gdb",
        miDebuggerPath = config.miDebuggerPath or "/usr/bin/gdb",
        setupCommands = config.setupCommands or {
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

load_vscode_launch_json()
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
