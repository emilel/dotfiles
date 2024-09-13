local strings = require('functions.strings')

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
  local relative_path = strings.get_relative_path()
  vim.fn.setreg('+', relative_path)
  print('Copied: ' .. relative_path)
end, { desc = 'Copy relative path' })

-- copy full path
vim.keymap.set('n', '<space>yP', function()
  local ful_path = strings.get_absolute_path()
  vim.fn.setreg('+', ful_path)
  print('Copied: ' .. ful_path)
end, { desc = 'Copy full path' })

-- copy file name
vim.keymap.set('n', '<space>yn', function()
  local file_name = strings.get_file_name()
  vim.fn.setreg('+', file_name)
  print('Copied: ' .. file_name)
end, { desc = 'Copy file name' })

-- copy branch name
vim.keymap.set('n', '<space>yb', function()
  local branch = strings.get_git_branch()
  vim.fn.setreg('+', branch)
  print('Copied: ' .. branch)
end, { desc = 'Copy branch name' })

-- copy relative file directory
vim.keymap.set('n', '<space>yd', function()
  local dir = strings.get_relative_directory()
  vim.fn.setreg('+', dir)
  print('Copied: ' .. dir)
end, { desc = 'Copy relative file directory path' })

-- copy absolute file directory
vim.keymap.set('n', '<space>yD', function()
  local dir = strings.get_absolute_directory()
  vim.fn.setreg('+', dir)
  print('Copied: ' .. dir)
end, { desc = 'Copy absolute file directory path' })

-- copy repository name
vim.keymap.set('n', '<space>yr', function()
  local repo_name = strings.get_repo_name()
  vim.fn.setreg('+', repo_name)
  print('Copied: ' .. repo_name)
end, { desc = 'Copy repository name' })

-- copy relative path and line number
vim.keymap.set('n', '<space>yl', function()
  local path = strings.get_relative_path()
  local line_number = strings.get_line()
  local file_info = string.format('%s:%d', path, line_number)
  vim.fn.setreg('+', file_info)
  print('Copied: ' .. file_info)
end, { desc = 'Copy file and line number' })

-- copy path in repository and line number
vim.keymap.set('n', '<space>yL', function()
  local file_path = strings.get_relative_to_repo_path()
  local line_number = strings.get_line()
  local file_info = string.format('%s:%d', file_path, line_number)
  vim.fn.setreg('+', file_info)
  print('Copied: ' .. file_info)
end, { desc = 'Copy file and line number' })

-- copy repository, branch and file
vim.keymap.set('n', '<space>ye', function()
  local repo_name = strings.get_repo_name()
  local branch_name = strings.get_git_branch()
  local file_path = strings.get_relative_to_repo_path()
  local repo_info = string.format('%s@%s %s', repo_name, branch_name, file_path)
  vim.fn.setreg('+', repo_info)
  print('Copied: ' .. repo_info)
end, { desc = 'Copy repository, branch and file' })

-- copy repository, branch, file and line number
vim.keymap.set('n', '<space>yE', function()
  local repo_name = strings.get_repo_name()
  local branch_name = strings.get_git_branch()
  local file_path = strings.get_relative_to_repo_path()
  local line_number = strings.get_line()
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
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('gv<esc>', true, true, true), 'n', true)
end, { desc = 'Append to copy register' })

-- open strings buffer
vim.keymap.set('n', '<space>+', function()
  strings.open_buffer()
  vim.api.nvim_feedkeys('P', "n", false)
end, { desc = 'Open strings buffer' })
