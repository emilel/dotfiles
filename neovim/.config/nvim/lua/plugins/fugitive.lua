return {
    'tpope/vim-fugitive',
    lazy = true,
    keys = {
        { '<c-g><c-g>', '<cmd>Git<cr><cmd>only<cr>', { desc = 'Open git' } },
        { '<c-g>j', '<cmd>Git pull<cr>', { desc = 'Git pull' } },
        { '<c-g>k', '<cmd>Git push<cr>', { desc = 'Git push' } },
        { '<c-g>K', '<cmd>Git push --force<cr>', { desc = 'Git push --force' } },
        { '<c-g>l', '<cmd>Git stash list<cr>' , { desc = 'List stash' } },
        { '<c-g>f', ':Git ', { desc = 'Run git command' } }
    }
}
