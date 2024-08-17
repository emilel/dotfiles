return {
    'tpope/vim-fugitive',
    lazy = true,
    keys = {
        { '<space>gg', '<cmd>Git<cr><cmd>only<cr>', { desc = 'Open git' } },
        { '<space>gj', '<cmd>Git pull<cr>', { desc = 'Git pull' } },
        { '<space>gk', '<cmd>Git push<cr>', { desc = 'Git push' } },
        { '<space>gc', ':Git ', { desc = 'Run git command' } }
    }
}
