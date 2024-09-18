local M = {}

M.get_git_branch = function()
  return vim.fn.systemlist('git rev-parse --abbrev-ref HEAD')[1]
end

M.get_relative_path = function()
  return vim.fn.expand('%:~:.')
end

M.get_relative_to_repo_path = function()
  local repo_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local file_path = vim.fn.expand('%:p')
  local relative_path = file_path:sub(#repo_root + 2)
  return relative_path
end

M.get_absolute_path = function()
  return vim.fn.expand('%:p')
end

M.get_repo_name = function()
  return vim.fn.systemlist('basename `git rev-parse --show-toplevel`')[1]
end

M.get_line = function()
  return vim.fn.line('.')
end

M.get_relative_directory = function()
  local file_directory = vim.fn.expand('%:p:h')
  local cwd = vim.fn.getcwd()
  local relative_directory = file_directory:sub(#cwd + 2) -- +2 to remove the trailing slash
  return relative_directory
end

M.get_absolute_directory = function()
  return vim.fn.expand('%:p:h')
end

M.get_file_name = function()
  local path = vim.api.nvim_buf_get_name(0)
  local file_name = ''
  for part in path:gmatch('([^/]+)') do
    file_name = part
  end
  return file_name
end

M.open_buffer = function()
  local filename = vim.fn.system("mktemp")
  vim.api.nvim_command('edit ' .. vim.fn.trim(filename))

  vim.keymap.set('n', '<cr><cr>', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local content = table.concat(lines, '\n')
    vim.fn.setreg('+', content)
    vim.cmd('bdelete!')
  end, { buffer = true, desc = 'Copy content and close buffer' })
end

M.escape_vim = function(string)
  local escaped_string = vim.fn.escape(string, '\\.^$*[]/')

  return escaped_string
end

return M
