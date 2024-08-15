return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        {
            '<space>f',
            function()
                require('telescope.builtin').find_files()
            end,
            desc = 'Find files'
        },
        {
            '<space>/',
            function()
                require('telescope.builtin').live_grep()
            end,
            desc = 'Grep all files'
        },
        {
            '<space>a',
            function()
                require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = false })
            end,
            desc = 'Go to buffer'
        },
    },
    config = function()
        require('telescope').setup({
            defaults = {
                layout_strategy = 'vertical',
                mappings = {
                    i = {
                        ['<esc>'] = require('telescope.actions').close,
                        ['<c-j>'] = require('telescope.actions').move_selection_next,
                        ['<c-k>'] = require('telescope.actions').move_selection_previous,
                        ["<c-x>"] = "delete_buffer"
                    }
                }
            },
            pickers = {
                find_files = {
                    hidden = true
                },
                live_grep = {
                    additional_args = function(_)
                        return { "--hidden" }
                    end
                },
            }
        })
    end,
    lazy = true
}
