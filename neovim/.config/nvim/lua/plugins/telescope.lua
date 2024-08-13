local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        {
            '<space>f',
            builtin.find_files,
            desc = 'Find files'
        },
        {
            '<space>/',
            builtin.live_grep,
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
        telescope.setup({
            defaults = {
                layout_strategy = 'vertical',
                mappings = {
                    i = {
                        ['<esc>'] = actions.close,
                        ['<c-j>'] = actions.move_selection_next,
                        ['<c-k>'] = actions.move_selection_previous,
                        ["<c-x>"] = "delete_buffer"
                    }
                }
            }
        })
    end,
    lazy = true
}
