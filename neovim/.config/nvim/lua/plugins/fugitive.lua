return {
    'tpope/vim-fugitive',
    lazy = true,
    keys = {
        { '<space>G', '<cmd>Git<cr><cmd>only<cr>', { desc = 'Open git' } },
        { '<space>g', ':Git ', { desc = 'Run git command' } }
    }
}
