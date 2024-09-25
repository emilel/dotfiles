vim.g.copilot_no_tab_map = true

return {
    'github/copilot.vim',
    lazy = false,
    keys = {
        { '<right>',   'copilot#Accept("\\<cr>")',    mode = 'i', expr = true,                   replace_keycodes = false, desc = 'Accept suggestion' },
        { '<s-right>', '<Plug>(copilot-accept-word)', mode = 'i', desc = 'Accept suggested word' },
        { '<s-down>',  '<Plug>(copilot-next)',        mode = 'i', desc = 'Cycle suggestion down' },
        { '<s-up>',    '<Plug>(copilot-previous)',    mode = 'i', desc = 'Cycle suggestion up' },
        { '<left>',    '<Plug>(copilot-dismiss)',    mode = 'i', desc = 'Discard suggestion' }
    }
}
