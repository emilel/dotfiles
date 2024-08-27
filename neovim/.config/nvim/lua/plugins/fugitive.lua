return {
    'tpope/vim-fugitive',
    lazy = true,
    keys = {
        { '<c-g>g', '<cmd>Git<cr><cmd>only<cr>', { desc = 'Open git' } },
        { '<c-g>j', '<cmd>Git pull<cr>', { desc = 'Git pull' } },
        { '<c-g>k', '<cmd>Git push<cr>', { desc = 'Git push' } },
        { '<c-g>c', ':Git ', { desc = 'Run git command' } }
    }
}
