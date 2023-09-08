local yank = {}

yank.path = function ()
    path = vim.api.nvim_buf_get_name(0)
    vim.fn.setreg('+', path)
    print('Set clipboard to file path')
end

yank.full_path = function ()
    path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    print('Set clipboard to file path')
end

return yank
