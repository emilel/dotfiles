return {
    'tpope/vim-fugitive',
    lazy = true,
    keys = {
        { '<c-g><c-g>', '<cmd>Git<cr><cmd>only<cr>', { desc = 'Open git' } },
        { '<c-g><c-j>', '<cmd>Git pull<cr>', { desc = 'Git pull' } },
        { '<c-g><c-k>', '<cmd>Git push<cr>', { desc = 'Git push' } },
        { '<c-g><c-f>', ':Git ', { desc = 'Run git command' } }
    }
}
