vim.g.copilot_no_tab_map = true

return {
    'github/copilot.vim',
    lazy = false,
    keys = {
        { '<right>', 'copilot#Accept("\\<cr>")', mode = 'i', expr = true, replace_keycodes = false }
    }
}
