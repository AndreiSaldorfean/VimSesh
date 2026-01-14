Builder_command = require('plugins.builder_command')
local M = {}

-- Variable to track the toggle state
local build_toggle_state = false
M.build_config = {}

function M.toggle_build_function()
  build_toggle_state = not build_toggle_state
  if build_toggle_state then
    local status = Builder_command.load_build_config()
    if status then
      vim.cmd([[
        augroup AutoBuild
          autocmd!
          autocmd BufWritePost * lua if Builder_command.is_in_target_folder() then Builder_command.run_build() end
        augroup END
      ]])
    else
      print("No valid build config loaded.")
    end
  else
    vim.cmd([[
      augroup AutoBuild
        autocmd!
      augroup END
    ]])
  end
end

vim.api.nvim_create_user_command('BuildToggle', function()
  M.toggle_build_function()
end, {})

return M
