return {
    'tpope/vim-fugitive',
    lazy = true,
    keys = {
        { '<space>g', '<cmd>Git<cr><cmd>only<cr>', { desc = 'Open git' } },
        { '<space>G', ':Git ', { desc = 'Run git command' } }
    }
}
