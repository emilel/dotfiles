-- copy file
vim.keymap.set('n', '<space>yf', 'gg0yG<c-o>', { desc = 'Copy entire file' })

-- copy relative path
vim.keymap.set('n', '<space>yp', function()
    local path = vim.api.nvim_buf_get_name(0)
    vim.fn.setreg('+', path)
    print('Relative path copied to clipboard')
end, { desc = 'Copy relative path' })

-- copy full path
vim.keymap.set('n', '<space>yP', function()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    print('Full path copied to clipboard')
end, { desc = 'Copy full path' })

-- copy file name
vim.keymap.set('n', '<space>yn', function()
    local path = vim.api.nvim_buf_get_name(0)
    local file_name = ""
    for part in path:gmatch("([^/]+)") do
        file_name = part
    end
    vim.fn.setreg('+', file_name)
end, { desc = 'Copy file name' })
