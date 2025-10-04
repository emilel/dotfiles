return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },

    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'none',
            ['<tab>'] = { 'show', 'fallback' },
            ['<c-j>'] = { 'select_next', 'fallback' },
            ['<c-k>'] = { 'select_prev', 'fallback' },
            ['<c-l>'] = { 'accept', 'snippet_forward', 'fallback' },
            ['<c-h>'] = { 'snippet_backward', 'fallback' },
            ['<c-d>'] = { 'show_documentation', 'hide_documentation', 'fallback' },
            ['<c-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
        },
        signature = { enabled = true, window = { show_documentation = true } },

        appearance = {
            nerd_font_variant = 'mono',
            kind_icons = {
                Text = "Te",
                Method = "Me",
                Function = "Fu",
                Constructor = "Co",
                Field = "Fd",
                Variable = "Vr",
                Property = "Pr",
                Class = "Cl",
                Interface = "In",
                Struct = "St",
                Module = "Mo",
                Unit = "Un",
                Value = "Va",
                Enum = "En",
                EnumMember = "Em",
                Keyword = "Ke",
                Constant = "Cs",
                Snippet = "Sn",
                Color = "Co",
                File = "Fi",
                Reference = "Re",
                Folder = "Di",
                Event = "Ev",
                Operator = "Op",
                TypeParameter = "Tp",
            },
        },
        completion = { documentation = { auto_show = true } },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        fuzzy = { implementation = "lua" }
    },
    opts_extend = { "sources.default" }
}
