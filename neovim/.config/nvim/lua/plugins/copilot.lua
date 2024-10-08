vim.g.copilot_no_tab_map = true

return {
    'github/copilot.vim',
    lazy = false,
    keys = {
        { '<c-right>',   'copilot#Accept("\\<cr>")',    mode = 'i', expr = true,                   replace_keycodes = false, desc = 'Accept suggestion' },
        { '<s-c-right>', '<Plug>(copilot-accept-word)', mode = 'i', desc = 'Accept suggested word' },
        { '<c-down>',  '<Plug>(copilot-next)',        mode = 'i', desc = 'Cycle suggestion down' },
        { '<c-up>',    '<Plug>(copilot-previous)',    mode = 'i', desc = 'Cycle suggestion up' },
        -- { '<left>',    '<Plug>(copilot-dismiss)',    mode = 'i', desc = 'Discard suggestion' }
    }
}
