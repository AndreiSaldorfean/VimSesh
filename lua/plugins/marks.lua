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

  if #project_marks == 0 then
    vim.notify("No marks in current project", vim.log.levels.INFO)
    return
  end

  -- Create a floating window
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Calculate split: marks list on left, preview on right
  local list_width = math.floor(width * 0.4)
  local preview_width = width - list_width - 3

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = list_width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " API Marks ",
    title_pos = "center",
  })

  -- Create preview window
  local preview_buf = vim.api.nvim_create_buf(false, true)
  local preview_win = vim.api.nvim_open_win(preview_buf, false, {
    relative = "editor",
    width = preview_width,
    height = height,
    row = row,
    col = col + list_width + 3,
    style = "minimal",
    border = "rounded",
    title = " Preview ",
    title_pos = "center",
  })

  -- Render marks list
  local function render_marks()
    local lines = {}
    for i, m in ipairs(project_marks) do
      local short = vim.fn.fnamemodify(m.file, ":~:.")
      lines[i] = string.format("%2d. %-30s %s:%d", i, m.name, short, m.row)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].buftype = "nofile"
  end

  -- Update preview
  local function update_preview()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    local mark = project_marks[line]
    if not mark then return end

    -- Load file content
    local ok, file_lines = pcall(vim.fn.readfile, mark.file)
    if not ok or not file_lines then 
      vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, { "Error loading file: " .. mark.file })
      return 
    end

    vim.api.nvim_buf_set_option(preview_buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, file_lines)
    
    -- Set filetype for syntax highlighting
    local ft = vim.filetype.match({ filename = mark.file }) or ""
    vim.api.nvim_buf_set_option(preview_buf, "filetype", ft)
    vim.api.nvim_buf_set_option(preview_buf, "modifiable", false)
    vim.api.nvim_buf_set_option(preview_buf, "buftype", "nofile")

    -- Center on marked line
    if vim.api.nvim_win_is_valid(preview_win) then
      pcall(vim.api.nvim_win_set_cursor, preview_win, { mark.row, mark.col })
      vim.api.nvim_win_call(preview_win, function()
        vim.cmd("normal! zz")
      end)
    end
  end

  -- Navigate and update preview
  local function move_cursor(delta)
    local new_line = vim.api.nvim_win_get_cursor(win)[1] + delta
    new_line = math.max(1, math.min(new_line, #project_marks))
    vim.api.nvim_win_set_cursor(win, { new_line, 0 })
    update_preview()
  end

  -- Jump to mark
  local function jump_to_mark()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    local mark = project_marks[line]
    if not mark then return end

    vim.api.nvim_win_close(win, true)
    vim.api.nvim_win_close(preview_win, true)
    vim.cmd("edit " .. vim.fn.fnameescape(mark.file))
    vim.api.nvim_win_set_cursor(0, { mark.row, mark.col })
  end

  -- Delete mark
  local function delete_mark()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    local mark = project_marks[line]
    if not mark then return end

    -- Remove from global marks
    load_marks()
    local new_marks = {}
    for _, m in ipairs(marks) do
      if not (m.project == mark.project and m.file == mark.file and m.row == mark.row and m.name == mark.name) then
        table.insert(new_marks, m)
      end
    end
    marks = new_marks
    save_marks()

    -- Remove from project_marks and re-render
    table.remove(project_marks, line)
    if #project_marks == 0 then
      vim.api.nvim_win_close(win, true)
      vim.api.nvim_win_close(preview_win, true)
      vim.notify("No more marks", vim.log.levels.INFO)
      return
    end

    vim.bo[buf].modifiable = true
    render_marks()
    local new_pos = math.min(line, #project_marks)
    vim.api.nvim_win_set_cursor(win, { new_pos, 0 })
    update_preview()
  end

  -- Move mark up/down
  local function move_mark(direction)
    local line = vim.api.nvim_win_get_cursor(win)[1]
    local new_line = line + direction
    if new_line < 1 or new_line > #project_marks then return end

    -- Swap in project_marks
    project_marks[line], project_marks[new_line] = project_marks[new_line], project_marks[line]

    -- Update global marks order
    load_marks()
    local project = get_project_root()
    local project_indices = {}
    for i, m in ipairs(marks) do
      if m.project == project then
        table.insert(project_indices, i)
      end
    end
    
    -- Reorder in global marks
    for i, idx in ipairs(project_indices) do
      marks[idx] = project_marks[i]
    end
    save_marks()

    vim.bo[buf].modifiable = true
    render_marks()
    vim.api.nvim_win_set_cursor(win, { new_line, 0 })
    update_preview()
  end

  -- Set keymaps
  local opts = { buffer = buf, noremap = true, silent = true }
  vim.keymap.set("n", "j", function() move_cursor(1) end, opts)
  vim.keymap.set("n", "k", function() move_cursor(-1) end, opts)
  vim.keymap.set("n", "<CR>", jump_to_mark, opts)
  vim.keymap.set("n", "dd", delete_mark, opts)
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_win_close(preview_win, true)
  end, opts)
  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_win_close(preview_win, true)
  end, opts)
  vim.keymap.set("n", "<C-j>", function() move_mark(1) end, opts)
  vim.keymap.set("n", "<C-k>", function() move_mark(-1) end, opts)

  -- Initial render
  render_marks()
  vim.api.nvim_win_set_cursor(win, { 1, 0 })
  update_preview()
end

vim.keymap.set("n", "<leader>am", M.add_mark, { desc = "Mark function (API)" })
vim.keymap.set("n", "<leader>ap", M.pick_marks, { desc = "Pick API marks" })
vim.keymap.set("n", "<leader>ad", M.remove_mark, { desc = "Remove mark at cursor" })

return M
