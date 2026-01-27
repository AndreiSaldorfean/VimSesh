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

-- Try: treesitter -> check if on function name specifically
local function ts_get_function_name_at_cursor()
  local ok, ts = pcall(require, "nvim-treesitter.ts_utils")
  if not ok then return nil end
  
  local node = ts.get_node_at_cursor()
  if not node then return nil end
  
  -- Check if we're on an identifier that's a function name
  local current_node = node
  while current_node do
    local node_type = current_node:type()
    
    -- For C: check if we're on a function_declarator or function name identifier
    if node_type == "function_declarator" or node_type == "identifier" then
      local parent = current_node:parent()
      if parent then
        local parent_type = parent:type()
        -- Check if parent is a function definition/declaration
        if parent_type == "function_definition" or parent_type == "declaration" then
          -- Try to extract the function name
          local text = vim.treesitter.get_node_text(current_node, 0)
          if text then
            -- If it contains parentheses, extract name before them
            local name = text:match("([%w_]+)%s*%(")
            if name then return name end
            -- If it's just an identifier, return it
            if text:match("^[%w_]+$") then return text end
          end
        end
      end
    end
    
    -- Move up the tree
    current_node = current_node:parent()
  end
  
  return nil
end

-- Fallback: use current line as name
local function fallback_name()
  local line = vim.api.nvim_get_current_line()
  -- Trim leading/trailing whitespace
  line = line:match("^%s*(.-)%s*$")
  
  if line == "" then
    return "(empty line)"
  end
  
  -- Truncate if too long (max 50 chars)
  if #line > 50 then
    return line:sub(1, 47) .. "..."
  end
  
  return line
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

  -- Create a fullscreen window with borders
  local buf = vim.api.nvim_create_buf(false, true)
  local width = vim.o.columns - 4
  local height = vim.o.lines - 4
  local row = 1
  local col = 1

  -- Calculate split: marks list 60%, preview 40%
  local list_width = math.floor(width * 0.6)
  local preview_width = width - list_width - 3

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = list_width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Marks ",
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
      local filename = vim.fn.fnamemodify(m.file, ":t")  -- Just the filename
      lines[i] = string.format("%2d. %-20s %s", i, filename .. ":" .. m.row .. ":" .. (m.col + 1), m.name)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].buftype = "nofile"
    
    -- Add syntax highlighting
    local ns = vim.api.nvim_create_namespace("marks_highlight")
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    
    for i, m in ipairs(project_marks) do
      local line_idx = i - 1
      local line = lines[i]
      
      -- Highlight the number (e.g., " 1.")
      local num_end = line:find("%.")
      if num_end then
        vim.api.nvim_buf_add_highlight(buf, ns, "Number", line_idx, 0, num_end)
      end
      
      -- Highlight the mark name/code
      local name_start = num_end and num_end + 1 or 0
      local filename_end = name_start + 21  -- 20 chars filename + 1 space
      vim.api.nvim_buf_add_highlight(buf, ns, "Directory", line_idx, name_start, filename_end)
      
      -- Highlight code string
      vim.api.nvim_buf_add_highlight(buf, ns, "String", line_idx, filename_end, -1)
    end
  end

  -- Update preview
  local function update_preview()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    local mark = project_marks[line]
    if not mark then return end
    -- Update preview window title with relative path
    local rel_path = vim.fn.fnamemodify(mark.file, ":~:.")
    vim.api.nvim_win_set_config(preview_win, {
      title = " " .. rel_path .. ":" .. mark.row .. " ",
      title_pos = "center",
    })
    -- Load file content
    local ok, file_lines = pcall(vim.fn.readfile, mark.file)
    if not ok or not file_lines then 
      vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, { "Error loading file: " .. mark.file })
      return 
    end

    -- Add relative path header
    local rel_path = vim.fn.fnamemodify(mark.file, ":~:.")
    local header = { "━━━ " .. rel_path .. ":" .. mark.row .. " ━━━", "" }
    local content = vim.list_extend(header, file_lines)

    vim.api.nvim_buf_set_option(preview_buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, content)
    
    -- Set filetype for syntax highlighting
    local ft = vim.filetype.match({ filename = mark.file }) or ""
    vim.api.nvim_buf_set_option(preview_buf, "filetype", ft)
    vim.api.nvim_buf_set_option(preview_buf, "modifiable", false)
    vim.api.nvim_buf_set_option(preview_buf, "buftype", "nofile")

    -- Highlight the header
    local header_ns = vim.api.nvim_create_namespace("preview_header")
    vim.api.nvim_buf_clear_namespace(preview_buf, header_ns, 0, -1)
    vim.api.nvim_buf_add_highlight(preview_buf, header_ns, "Comment", 0, 0, -1)

    -- Clear previous highlights
    local mark_ns = vim.api.nvim_create_namespace("mark_cursor")
    vim.api.nvim_buf_clear_namespace(preview_buf, mark_ns, 0, -1)

    -- Highlight the marked line (offset by 2 for header)
    local mark_line = mark.row + 1  -- +2 for header, -1 for 0-index
    vim.api.nvim_buf_add_highlight(preview_buf, mark_ns, "CursorLine", mark_line, 0, -1)
    
    -- Add virtual text showing cursor position
    vim.api.nvim_buf_set_extmark(preview_buf, mark_ns, mark_line, mark.col, {
      virt_text = { { "█", "Search" } },
      virt_text_pos = "overlay",
    })

    -- Center on marked line
    if vim.api.nvim_win_is_valid(preview_win) then
      pcall(vim.api.nvim_win_set_cursor, preview_win, { mark.row + 2, mark.col })
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
  vim.keymap.set("n", "<Down>", function() move_cursor(1) end, opts)
  vim.keymap.set("n", "<Up>", function() move_cursor(-1) end, opts)
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

  -- Auto-update preview on cursor move
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = buf,
    callback = function()
      update_preview()
    end,
  })

  -- Initial render
  render_marks()
  vim.api.nvim_win_set_cursor(win, { 1, 0 })
  update_preview()
end

function M.jump_to_mark(index)
  local project_marks = get_project_marks()
  if #project_marks == 0 then
    vim.notify("No marks in current project", vim.log.levels.WARN)
    return
  end
  
  local mark = project_marks[index]
  if not mark then
    vim.notify("Mark " .. index .. " does not exist", vim.log.levels.WARN)
    return
  end
  
  vim.cmd("edit " .. vim.fn.fnameescape(mark.file))
  vim.api.nvim_win_set_cursor(0, { mark.row, mark.col })
  vim.notify("Jumped to mark " .. index .. ": " .. mark.name, vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>am", M.add_mark, { desc = "Mark function (API)" })
vim.keymap.set("n", "<leader>ap", M.pick_marks, { desc = "Pick API marks" })
vim.keymap.set("n", "<leader>ad", M.remove_mark, { desc = "Remove mark at cursor" })

-- Quick access keymaps
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function() M.jump_to_mark(i) end, { desc = "Jump to mark " .. i })
end

return M
