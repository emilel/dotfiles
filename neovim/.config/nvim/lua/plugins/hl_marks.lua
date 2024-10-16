return {
    dir = vim.fn.stdpath('config') .. '/lua/hl_marks',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
        require('hl_marks').setup()
    end,
    lazy = false,
    keys = {
        { mode = 'x', "'",        function() require('hl_marks.api').set_visual() end,    desc = 'Set HL mark' },
        { mode = 'n', '<space>x', function() require('hl_marks.api').remove_normal() end, desc = 'Remove HL mark' },
        { mode = 'n', '<space>a', function() require('hl_marks.api').find_hl_marks() end, desc = 'Jump to HL mark' },
    },
}
