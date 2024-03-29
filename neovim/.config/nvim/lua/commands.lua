vim.api.nvim_create_user_command('TempMD', function()
    require('functions.temp').open_yank_buffer('markdown')
end, { nargs = '*' })

vim.api.nvim_create_user_command('SaveToCopy', function()
    vim.keymap.set('n', '<c-space>', function()
        vim.cmd('write')
        require('functions.yank').file()
        vim.cmd('e#')
    end, { desc = 'Copy buffer', buffer = true })
end, { nargs = '*' })

vim.api.nvim_create_user_command('TW', function(arg)
    local width
    if arg.args == "" then
        width = 65
    else
        width = arg.args
    end

    vim.o.textwidth = tonumber(width)
    vim.o.colorcolumn = tostring(tonumber(width) + 1)
end, { nargs = '?' })
