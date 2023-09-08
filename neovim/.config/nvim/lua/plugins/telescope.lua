return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = true,
    keys = {
        { '<space>/', function() require('telescope.builtin').live_grep() end, desc = 'Grep all files' },
        {
            '<space>a',
            function()
                require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true })
            end,
            desc = 'Go to buffer'
        },
        { '<space>T', function() require('telescope.builtin').resume() end,    desc = 'Resume telescope' },
        { '<space>m', function() require('telescope.builtin').keymaps() end,    desc = 'Resume telescope' }
    },
    config = function()
        require('telescope').setup({
            defaults = {
                preview = true,
                layout_strategy = 'vertical',
                layout_config = {
                    preview_cutoff = 0,
                },
                mappings = {
                    i = {
                        ['<c-h>'] = require('telescope.actions').toggle_selection,
                        ['<c-j>'] = require('telescope.actions').move_selection_next,
                        ['<c-k>'] = require('telescope.actions').move_selection_previous,
                        ['<esc>'] = require('telescope.actions').close,
                        ['<c-l>'] = require('telescope.actions').smart_send_to_qflist
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
    end
}
