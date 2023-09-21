return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { "nvim-telescope/telescope-fzy-native.nvim" },
    },
    lazy = true,
    keys = {
        {
            '<space>/',
            function() require('telescope.builtin').live_grep() end,
            desc =
            'Grep all files'
        },
        {
            '<space>a',
            function()
                require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true })
            end,
            desc = 'Go to buffer'
        },
        {
            '<space>p',
            function()
                require('telescope.builtin').registers()
            end,
            desc = 'Paste from register'
        },
        {
            '<space>p',
            function()
                vim.api.nvim_feedkeys('d', 'x', true)
                require('telescope.builtin').registers()
            end,
            mode = 'x',
            desc = 'Paste from register'
        },
        {
            '<space>t',
            function() require('telescope.builtin').resume() end,
            desc =
            'Resume telescope'
        },
        {
            '<space>m',
            function() require('telescope.builtin').keymaps() end,
            desc =
            'Resume telescope'
        },
        {
            '<space>*',
            '"yy:lua require("telescope.builtin").grep_string({ search = "<c-r>y" })<cr>',
            mode = 'v',
            desc = 'Search for highlighted string in workspace'
        },
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
                        ['<c-l>'] = require('telescope.actions').smart_send_to_qflist,
                        ['<c-space>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_previous,
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
                grep_string = {
                    additional_args = function(_)
                        return { '--hidden' }
                    end,
                }
            }
        })
    end
}
