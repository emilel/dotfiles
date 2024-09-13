local yank = require('functions.yank')

vim.api.nvim_create_user_command('Temp', function()
    yank.open_buffer()
    yank.set_exit_keymap('q!')
end, { nargs = '*' })
