local M = {}

M.open_buffer = function()
  local filename = vim.fn.system("mktemp")
  vim.diagnostic.config({virtual_text=false})
  vim.opt_local.signcolumn = 'no'
  vim.api.nvim_command('edit ' .. vim.fn.trim(filename))
end

M.set_exit_keymap = function(command)
  vim.keymap.set('n', '<cr><cr>', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local content = table.concat(lines, '\n')
    vim.fn.setreg('+', content)
    vim.cmd(command)
  end, { buffer = true, desc = 'Copy content and close buffer' })
end

return M
