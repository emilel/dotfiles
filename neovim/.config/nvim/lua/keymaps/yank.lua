local function get_git_branch()
  return vim.fn.systemlist('git rev-parse --abbrev-ref HEAD')[1]
end

local function get_relative_path()
  return vim.fn.expand('%:~:.')
end

local function get_relative_to_repo_path()
  local repo_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local file_path = vim.fn.expand('%:p')
  local relative_path = file_path:sub(#repo_root + 2)
  return relative_path
end

local function get_absolute_path()
  return vim.fn.expand('%:p')
end

local function get_repo_name()
  return vim.fn.systemlist('basename `git rev-parse --show-toplevel`')[1]
end

local function get_line()
  return vim.fn.line('.')
end

local function get_relative_directory()
  local file_directory = vim.fn.expand('%:p:h')
  local cwd = vim.fn.getcwd()
  local relative_directory = file_directory:sub(#cwd + 2) -- +2 to remove the trailing slash
  return relative_directory
end

local function get_absolute_directory()
  return vim.fn.expand('%:p:h')
end

local function get_file_name()
  local path = vim.api.nvim_buf_get_name(0)
  local file_name = ''
  for part in path:gmatch('([^/]+)') do
    file_name = part
  end
  return file_name
end

-- copy line content
vim.keymap.set('n', '<space>yy', 'my^y$`y', { desc = 'Copy line content' })

-- copy entire file
vim.keymap.set('n', '<space>yf', function()
  local scroll_pos = vim.fn.winsaveview()
  vim.cmd('normal gg0yG', 'n', true)
  vim.fn.winrestview(scroll_pos)
end, { desc = 'Copy entire file' })

-- copy relative path
vim.keymap.set('n', '<space>yp', function()
  local relative_path = get_relative_path()
  vim.fn.setreg('+', relative_path)
  print('Copied: ' .. relative_path)
end, { desc = 'Copy relative path' })

-- copy full path
vim.keymap.set('n', '<space>yP', function()
  local ful_path = get_absolute_path()
  vim.fn.setreg('+', ful_path)
  print('Copied: ' .. ful_path)
end, { desc = 'Copy full path' })

-- copy file name
vim.keymap.set('n', '<space>yn', function()
  local file_name = get_file_name()
  vim.fn.setreg('+', file_name)
  print('Copied: ' .. file_name)
end, { desc = 'Copy file name' })

-- copy branch name
vim.keymap.set('n', '<space>yb', function()
  local branch = get_git_branch()
  vim.fn.setreg('+', branch)
  print('Copied: ' .. branch)
end, { desc = 'Copy branch name' })

-- copy relative file directory
vim.keymap.set('n', '<space>yd', function()
  local dir = get_relative_directory()
  vim.fn.setreg('+', dir)
  print('Copied: ' .. dir)
end, { desc = 'Copy relative file directory path' })

-- copy absolute file directory
vim.keymap.set('n', '<space>yD', function()
  local dir = get_absolute_directory()
  vim.fn.setreg('+', dir)
  print('Copied: ' .. dir)
end, { desc = 'Copy absolute file directory path' })

-- copy repository name
vim.keymap.set('n', '<space>yr', function()
  local repo_name = get_repo_name()
  vim.fn.setreg('+', repo_name)
  print('Copied: ' .. repo_name)
end, { desc = 'Copy repository name' })

-- copy relative path and line number
vim.keymap.set('n', '<space>yl', function()
  local path = get_relative_path()
  local line_number = get_line()
  local file_info = string.format('%s:%d', path, line_number)
  vim.fn.setreg('+', file_info)
  print('Copied: ' .. file_info)
end, { desc = 'Copy file and line number' })

-- copy path in repository and line number
vim.keymap.set('n', '<space>yL', function()
  local file_path = get_relative_to_repo_path()
  local line_number = get_line()
  local file_info = string.format('%s:%d', file_path, line_number)
  vim.fn.setreg('+', file_info)
  print('Copied: ' .. file_info)
end, { desc = 'Copy file and line number' })

-- copy repository, branch and file
vim.keymap.set('n', '<space>ye', function()
  local repo_name = get_repo_name()
  local branch_name = get_git_branch()
  local file_path = get_relative_to_repo_path()
  local repo_info = string.format('%s@%s %s', repo_name, branch_name, file_path)
  vim.fn.setreg('+', repo_info)
  print('Copied: ' .. repo_info)
end, { desc = 'Copy repository, branch and file' })

-- copy repository, branch, file and line number
vim.keymap.set('n', '<space>yE', function()
  local repo_name = get_repo_name()
  local branch_name = get_git_branch()
  local file_path = get_relative_to_repo_path()
  local line_number = get_line()
  local repo_info = string.format('%s@%s %s:%d', repo_name, branch_name, file_path, line_number)
  vim.fn.setreg('+', repo_info)
  print('Copied: ' .. repo_info)
end, { desc = 'Copy repository, branch, file and line number' })

-- append to copy register
vim.keymap.set('x', 'Y', function()
  vim.cmd('normal! "yy')
  local selected_text = vim.fn.getreg('y')
  local current_clipboard = vim.fn.getreg('+')
  local new_clipboard_content = current_clipboard .. '\n' .. selected_text
  vim.fn.setreg('+', new_clipboard_content)
end, { desc = 'Append to copy register' })

-- open yank buffer
vim.keymap.set('n', '<space>+', function()
  -- Create a temporary file and edit it
  local filetype = vim.bo.filetype
  local filename = vim.fn.system("mktemp")
  vim.api.nvim_command('edit ' .. vim.fn.trim(filename))
  vim.api.nvim_buf_set_option(0, 'filetype', filetype)
  vim.api.nvim_feedkeys("p", "n", false)

  vim.keymap.set('n', '<cr><cr>', function()
    vim.cmd('normal! ggVGy') -- yank all lines
    vim.cmd('bdelete!')
  end, { buffer = true, desc = 'Copy content and close buffer' })
end, { desc = 'Open yank buffer' })
