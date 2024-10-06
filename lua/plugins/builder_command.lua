-- Example
-- {
--   "buildDir": "build"
--   "command": "make -j12" -- this is the build command that is executed after cmake
--   "executable": "main.exe"
--   "dirs": ["dir1","dr2","dir3"]
-- }


local function asyncJob(command)
  vim.defer_fn(function()
  vim.fn.jobstart(command, {
    on_stdout = function(_, data)
      -- Process the output
      print(table.concat(data, "\n"))
    end,
    on_stderr = function(_, data)
      -- Handle errors if needed
      print(table.concat(data, "\n"))
    end,
    on_exit = function(_, exit_code)
      -- Do something when the command finishes
      print("Command exited with code:", exit_code)
    end
  })
  end, 200) -- Delay for 2000 milliseconds (2 seconds)
end

local M = {}

M.build_config = {}

function M.load_build_config()
  local file = io.open("buildConfig.json", "r")
  if not file then
    print("Could not open file buildConfig.json")
    return false
  end

  -- Read file content
  local content = file:read("*a")
  file:close()

  -- Parse JSON (assuming you have a JSON parser like 'dkjson' or 'lunajson' installed)
  local json = vim.fn.json_decode(content)

  if json then
    M.build_config = json
    M.build_config = json
    return true
  else
    print("Failed to parse JSON buildConfig.json")
    return false
  end
end

-- Check if the current file belongs to one of the specified dirs in buildConfig.json
function M.is_in_target_folder()
  if not M.build_config or not M.build_config.dirs then
    return false
  end

  local current_dir = vim.fn.expand('%:p:h')
  local target_folders = M.build_config.dirs

  -- Check if current directory is part of any of the target folders
  for _, folder in ipairs(target_folders) do
    if current_dir:find(folder, 1, true) then
      return true
    end
  end
  return false
end

function M.run_build()
  local build_command = 'cd ' ..
      M.build_config.buildDir .. ' && ' ..
      M.build_config.command .. ' > /tmp/link &&'
  local run_command = './' .. M.build_config.executable .. ' > /tmp/link'
  asyncJob('sh -c "clear > /tmp/link && ' .. build_command .. run_command .. '"')
end

return M
