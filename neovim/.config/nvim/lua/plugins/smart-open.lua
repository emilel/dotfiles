vim.api.nvim_create_user_command('OpenFile', function()
    local telescope = require('telescope')
    -- telescope.load_extension("smart_open")
    telescope.extensions.smart_open.smart_open({
        cwd_only = true
    })
end, { nargs = '*' })

return {
    'danielfalk/smart-open.nvim',
    lazy = true,
    keys = {
        {
            '<space>f',
            function()
                require('telescope').extensions.smart_open.smart_open({
                    cwd_only = true
                })
            end,
            desc = 'Open file in current working directory'
        },
        {
            '<space>F',
            function()
                require('telescope').extensions.smart_open.smart_open({
                    cwd_only = false
                })
            end,
            desc = 'Open any file'
        },
    },
    config = function()
        require('telescope').load_extension("smart_open")
    end,
    dependencies = {
        'kkharji/sqlite.lua'
    }
}
