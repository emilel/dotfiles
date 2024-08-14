return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function ()
        require('nvim-treesitter.configs').setup({
            highlight = { enable = true },
            indent = { enable = true, disable = { 'python' } },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<backspace>',
                    node_incremental = '<backspace>',
                    node_decremental = '<delete>',
                    -- scope_incremental = '+',
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        -- ['a,'] = '@parameter.outer',
                        -- ['i,'] = '@parameter.inner',
                        ["ac"] = "@call.outer",
                        ["ic"] = "@call.inner",
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['al'] = '@class.outer',
                        ['il'] = '@class.inner',
                    },
                },
            },
            swap = { enable = true, swap_next = { [',>'] =
            '@parameter.outer', }, swap_previous = { [',<'] =
            '@parameter.inner', }, },
        })
    end,
    opts = {}
}
