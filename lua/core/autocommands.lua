--========================================================
--                      Local functions
--========================================================
local function get_commit_hashes()
  local current_line = vim.fn.getline(".")
  local next_line = vim.fn.getline(vim.fn.line(".") + 1)

  local function extract_hash(line)
    return line:match("%[(.-)%]")
  end

  local hash1 = extract_hash(current_line)
  local hash2 = extract_hash(next_line)

  return hash1, hash2
end


--========================================================
--                       AUTO COMMANDS
--========================================================
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("Neotree close")
    vim.cmd("lua require('dapui').close()")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local start_time = vim.fn.reltime()
        vim.schedule(function()
            local elapsed_time = vim.fn.reltimefloat(vim.fn.reltime(start_time)) * 1000
            print(string.format("Buffer loaded in %.0f ms", elapsed_time))
        end)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "floggraph",
  callback = function()

    vim.keymap.set("n", "<CR>",
      function()
        local hash1, hash2 = get_commit_hashes()
        vim.cmd("DiffviewOpen " ..hash2..".."..hash1 )
      end,
      { buffer = true, desc = "Open commit in Diffview" }
    )

    vim.keymap.set("n", "sf",
      function()
        local hash = get_commit_hashes()
        vim.cmd("Git show --name-only " .. hash)
      end,
      { buffer = true, desc = "Open commit in files" }
    )
  end,
})


vim.api.nvim_create_autocmd("FileType", {
    pattern = "floggraph",
    callback = function()
        vim.api.nvim_set_hl(0, "FlogMergeCommit", { bg = "#454545"})
        vim.fn.matchadd("FlogMergeCommit", "Merge branch")
    end,
})

