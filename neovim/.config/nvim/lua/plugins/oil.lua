return {
    'stevearc/oil.nvim',
    opts = {
        view_options = {
            show_hidden = true,
        },
    },
    keys = {
        { '-', '<cmd>Oil<cr>', { desc = "Open file picker in current file's directory" } },
        { '_', '<cmd>Oil .<cr>', { desc = "Open file picker in current working directory" } },
    },
    cmd = {
        'Oil',
    },
}
