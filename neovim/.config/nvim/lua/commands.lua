vim.api.nvim_create_user_command('TempMD', function()
    require('functions.temp').create_temporary_yank_buffer('markdown')
end, { nargs = '*' })
