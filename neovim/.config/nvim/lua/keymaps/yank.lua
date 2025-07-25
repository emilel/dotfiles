local strings = require('functions.strings')
local yank = require('functions.yank')

-- copy line content
vim.keymap.set('n', '<space>yy', 'my^y$`y', { desc = 'Copy line content' })

-- copy entire file
vim.keymap.set('n', '<space>yf', function()
  local scroll_pos = vim.fn.winsaveview()
  vim.cmd('normal gg0yG', 'n', true)
  vim.fn.winrestview(scroll_pos)
end, { desc = 'Copy entire file' })

-- copy file name and content
vim.keymap.set('n', '<space>yN', function()
  local file_name = strings.get_file_name()
  local filetype = vim.bo.filetype
  local scroll_pos = vim.fn.winsaveview()
  vim.cmd('normal! gg0yG', 'n', true)
  vim.fn.winrestview(scroll_pos)
  local file_content = vim.fn.getreg('"')
  local formatted_content = string.format(
    "%s:\n\n```%s\n%s\n```",
    file_name,
    filetype,
    file_content
  )
  vim.fn.setreg('+', formatted_content)
  print('Copied \'' .. file_name .. '\' and ' .. #vim.fn.split(file_content, '\n') .. ' lines')
end, { desc = 'Copy file name and content' })

-- copy relative path
vim.keymap.set('n', '<space>yp', function()
  local relative_path = strings.get_relative_path()
  vim.fn.setreg('+', relative_path)
  print('Copied: ' .. relative_path)
end, { desc = 'Copy relative path' })

-- copy relative path and file content
vim.keymap.set('n', '<space>yF', function()
  local relative_path = strings.get_relative_path()
  local filetype = vim.bo.filetype
  local scroll_pos = vim.fn.winsaveview()
  vim.cmd('normal! gg0yG', 'n', true)
  vim.fn.winrestview(scroll_pos)
  local file_content = vim.fn.getreg('"')
  local formatted_content = string.format(
    "%s:\n\n```%s\n%s\n```",
    relative_path,
    filetype,
    file_content
  )
  vim.fn.setreg('+', formatted_content)
  print('Copied \'' .. relative_path .. '\' and ' .. #vim.fn.split(file_content, '\n') .. ' lines')
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
  local name = strings.get_file_name()
  local line_number = strings.get_line()
  local file_info = string.format('%s:%d', name, line_number)
  vim.fn.setreg('+', file_info)
  print('Copied: ' .. file_info)
end, { desc = 'Copy file and line number' })

-- copy gdb command to set breakpoint
vim.keymap.set('n', '<space>yg', function()
  local name = strings.get_file_name()
  local line_number = strings.get_line()
  local command = string.format('break %s:%d', name, line_number)
  vim.fn.setreg('+', command)
  print('Copied: ' .. command)
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

vim.keymap.set('x', '<space>y', function()
  local mode = vim.fn.mode()

  vim.cmd('normal! "yy')
  local selected_text = vim.fn.getreg('y')
  local current_clipboard = vim.fn.getreg('+')

  local new_clipboard_content
  if mode:sub(1, 1) == 'v' then
    vim.cmd('normal! "y')
    new_clipboard_content = current_clipboard .. '\n' .. selected_text
  else
    vim.cmd('normal! "yy')
    new_clipboard_content = current_clipboard .. selected_text
  end
  vim.fn.setreg('+', new_clipboard_content)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('gv<esc>', true, true, true), 'n', true)
end, { desc = 'Append to copy register based on mode' })

-- open strings buffer
vim.keymap.set('n', '<space>+', function()
  local filetype = vim.bo.filetype
  yank.open_buffer()
  vim.bo.filetype = filetype
  yank.set_exit_keymap('bd!')
  vim.api.nvim_feedkeys('P', "n", false)
end, { desc = 'Open strings buffer' })

-- copy code block
vim.keymap.set('x', 'Y', function()
  local ft = vim.bo.filetype
  vim.cmd('normal! y')
  -- remove exactly one trailing newline from the yanked text
  local content = vim.fn.getreg('"'):gsub('\n$', '')
  local fenced = string.format("```%s\n%s\n```", ft, content)
  vim.fn.setreg('+', fenced)
  print('Copied ' .. #vim.fn.split(content, '\n') .. ' fenced lines')
end, { desc = 'Copy visually-selected text as a fenced code block' })
