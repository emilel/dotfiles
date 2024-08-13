local yank = require('functions.yank')

local temp = {}

temp.open_yank_buffer = function(arg)
    local filetype = arg or "markdown"

    local filename = vim.fn.system("mktemp")
    vim.api.nvim_command('edit ' .. vim.fn.trim(filename))
    vim.api.nvim_buf_set_option(0, 'filetype', filetype)
end

temp.selection = function()
    vim.api.nvim_feedkeys('y', 'x', true)
    yank.remove_leading_and_trailing_newlines()
    temp.open_yank_buffer(vim.bo.filetype)
    vim.api.nvim_feedkeys('P', 'n', true)
end

temp.file = function()
    yank.file()
    yank.remove_leading_and_trailing_newlines()
    temp.open_yank_buffer(vim.bo.filetype)
    vim.api.nvim_feedkeys('P', 'n', true)
end

temp.edit_register = function(arg)
    temp.open_yank_buffer(vim.bo.filetype)
    vim.api.nvim_feedkeys('P', 'n', true)
end

return temp
