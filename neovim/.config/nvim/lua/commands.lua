local yank = require('functions.yank')

vim.api.nvim_create_user_command('TempFile', function()
    yank.open_buffer()
    yank.set_exit_keymap('q!')
end, { nargs = '*' })

vim.api.nvim_create_user_command('Pipe', function(opts)
    local path = opts.args

    if vim.loop.fs_stat(path) then
        vim.cmd('edit ' .. vim.fn.fnameescape(path))
        vim.keymap.set('n', '<cr><cr>', '<cmd>wq<cr>', { buffer = true, desc = 'Write to stdout' })
    else
        print('Error: Path does not exist: ' .. path)
    end
end, { nargs = 1 })

vim.api.nvim_create_user_command('Temp', function()
    yank.open_buffer()
    yank.set_exit_keymap('bd!')
end, { nargs = '*' })
