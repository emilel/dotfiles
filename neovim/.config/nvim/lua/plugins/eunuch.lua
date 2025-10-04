return {
    'tpope/vim-eunuch',
    keys = {
        {
            '<space>r',
            function()
                local filename = vim.fn.expand('%:t')
                local file_root, extension = filename:match('^(.*)%.(.*)$')

                if not file_root then
                    file_root = filename
                end

                vim.api.nvim_feedkeys(':Rename ' .. filename, 'n', false)

                if extension then
                    local left_moves = #extension + 1
                    local move_left_keys = string.rep('<Left>', left_moves)
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(move_left_keys, true, false, true), 'n', false)
                end
            end,
            desc = 'Rename current file'
        },
        {
            '<space>R',
            function()
                local filename = vim.fn.expand('%:t')
                vim.api.nvim_feedkeys(':Rename ' .. filename, 'n', false)
            end,
            desc = 'Change extension'
        },
        { '<space>X', '<cmd>Delete<cr>', desc = 'Delete current file' }
    }
}
