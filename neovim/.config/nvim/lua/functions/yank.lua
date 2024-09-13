local M = {}

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

return M
