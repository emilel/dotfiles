return {
    'nvim-lualine/lualine.nvim',
    opts = {
        options = {
            icons_enabled = false,
            theme = 'jellybeans',
            component_separators = '|',
            section_separators = '',
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { { 'filename', path = 1 } },
            lualine_c = {
                function()
                    local last
                    for token in os.getenv("PWD"):gmatch("/[^/]*") do
                        last = token:sub(2)
                    end

                    return last
                end,
                'branch'
            },
        }
    },
}
