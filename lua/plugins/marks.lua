local M = {}

local uv = vim.uv or vim.loop
local marks = {}
local marks_path = vim.fn.stdpath("data") .. "/api_function_marks.json"

local function read_file(path)
  local fd = uv.fs_open(path, "r", 420)
  if not fd then return nil end
  local stat = uv.fs_fstat(fd)
  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)
  return data
end

local function write_file(path, data)
  local fd = uv.fs_open(path, "w", 420)
  if not fd then return false end
  uv.fs_write(fd, data, 0)
  uv.fs_close(fd)
  return true
end

local function load_marks()
  local data = read_file(marks_path)
  if not data or data == "" then
    marks = {}
    return
  end
  local ok, decoded = pcall(vim.json.decode, data)
  if ok and type(decoded) == "table" then
    marks = decoded
  else
    marks = {}
  end
end

local function save_marks()
  write_file(marks_path, vim.json.encode(marks))
end

local function normalize_path(p)
  return vim.fn.fnamemodify(p, ":p")
end

local function get_project_root()
  -- Try git root first
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(vim.fn.getcwd()) .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error == 0 and git_root and git_root ~= "" then
    return normalize_path(git_root)
  end
  -- Fallback to current working directory
  return normalize_path(vim.fn.getcwd())
end

local function get_project_marks()
  load_marks()
  local root = get_project_root()
  local project_marks = {}
  for _, m in ipairs(marks) do
    if m.project == root then
      table.insert(project_marks, m)
    end
  end
  return project_marks
end

local function get_cursor_mark()
  local buf = vim.api.nvim_get_current_buf()
  local file = normalize_path(vim.api.nvim_buf_get_name(buf))
  if file == "" then return nil end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- 1-based row, 0-based col
  return { file = file, row = row, col = col }
end

-- Try: treesitter -> nearest function
local function ts_get_function_name_at_cursor()
  local ok, ts = pcall(require, "nvim-treesitter.ts_utils")
  if not ok then return nil end
  local node = ts.get_node_at_cursor()
  while node do
    local t = node:type()
    -- common C nodes: function_definition, declaration, function_declarator
    if t == "function_definition" or t == "declaration" then
      -- heuristic: grab identifier child
      local text = vim.treesitter.get_node_text(node, 0)
      if text and text:find("%(") then
        -- best-effort name extraction
        local name = text:match("([%w_]+)%s*%(")
        if name then return name end
      end
    end
    node = node:parent()
  end
  return nil
end

-- Fallback: use current word as name
local function fallback_name()
  local w = vim.fn.expand("<cword>")
  if w and w ~= "" then return w end
  return "(unnamed)"
end

function M.add_mark()
  load_marks()

  local pos = get_cursor_mark()
  if not pos then
    vim.notify("No file name for this buffer", vim.log.levels.WARN)
    return
  end

  local name = ts_get_function_name_at_cursor() or fallback_name()
  local project = get_project_root()

  -- de-dup by project+file+row+name
  for _, m in ipairs(marks) do
    if m.project == project and m.file == pos.file and m.row == pos.row and m.name == name then
      vim.notify("Mark already exists: " .. name, vim.log.levels.INFO)
      return
    end
  end

  table.insert(marks, {
    name = name,
    file = pos.file,
    row = pos.row,
    col = pos.col,
    project = project,
    added_at = os.time(),
  })
  save_marks()
  vim.notify("Marked: " .. name .. " [" .. vim.fn.fnamemodify(project, ":t") .. "]", vim.log.levels.INFO)
end

function M.remove_mark()
  load_marks()
  local pos = get_cursor_mark()
  if not pos then return end
  local project = get_project_root()

  local new = {}
  local removed = 0
  for _, m in ipairs(marks) do
    if m.project == project and m.file == pos.file and m.row == pos.row then
      removed = removed + 1
    else
      table.insert(new, m)
    end
  end
  marks = new
  save_marks()
  vim.notify("Removed " .. removed .. " mark(s)", vim.log.levels.INFO)
end

function M.pick_marks()
  local project_marks = get_project_marks()
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("fzf-lua not installed", vim.log.levels.ERROR)
    return
  end

  if #project_marks == 0 then
    vim.notify("No marks in current project", vim.log.levels.INFO)
    return
  end

  -- Build file:line:col entries for fzf files format  
  local file_entries = {}
  for i, m in ipairs(project_marks) do
    table.insert(file_entries, string.format("%s:%d:%d: %s", m.file, m.row, m.col + 1, m.name))
  end

  fzf.fzf_exec(file_entries, {
    prompt = "API marks> ",
    previewer = "builtin",
    actions = {
      ["default"] = function(selected)
        if not selected or not selected[1] then return end
        local entry = selected[1]
        local file, line, col = entry:match("^(.+):(%d+):(%d+):")
        if not file then return end
        vim.cmd("edit " .. vim.fn.fnameescape(file))
        vim.api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) - 1 })
      end,
      ["ctrl-d"] = function(selected)
        if not selected or not selected[1] then return end
        local entry = selected[1]
        local file, line = entry:match("^(.+):(%d+):")
        if not file then return end
        -- Remove from global marks list
        load_marks()
        local new_marks = {}
        for _, mark in ipairs(marks) do
          if not (mark.file == file and mark.row == tonumber(line)) then
            table.insert(new_marks, mark)
          end
        end
        marks = new_marks
        save_marks()
        vim.notify("Deleted mark", vim.log.levels.INFO)
      end,
    },
  })
end

vim.keymap.set("n", "<leader>am", M.add_mark, { desc = "Mark function (API)" })
vim.keymap.set("n", "<leader>ap", M.pick_marks, { desc = "Pick API marks" })
vim.keymap.set("n", "<leader>ad", M.remove_mark, { desc = "Remove mark at cursor" })

return M
