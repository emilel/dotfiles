function open_oil_in_real_dir()
    local current_file = vim.fn.expand('%:p')
    local real_file = vim.loop.fs_realpath(current_file)

    if real_file then
        local real_dir = vim.fn.fnamemodify(real_file, ':h')
        require('oil').open(real_dir)
    else
        require('oil').open()
    end
end

return {
    'stevearc/oil.nvim',
    opts = {
        view_options = {
            show_hidden = true,
        },
    },
    keys = {
        { '-',open_oil_in_real_dir,   { desc = "Open file picker in current file's directory" } },
        { '_', '<cmd>Oil .<cr>', { desc = "Open file picker in current working directory" } },
    },
    cmd = {
        'Oil',
    },
}
