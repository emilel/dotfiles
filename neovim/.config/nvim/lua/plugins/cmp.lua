-- vim.opt.completeopt = { 'menu', 'menuone', 'noselect ' }

return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'L3MON4D3/LuaSnip' },
        { 'rafamadriz/friendly-snippets' },
        { 'neovim/nvim-lspconfig' },
    },
    ft = { 'lua', 'sh', 'zsh', 'bash', 'swayconfig', 'gitignore' },
    lazy = true,
    config = function()
        local lspconfig = require('lspconfig')
        local lsp_defaults = lspconfig.util.default_config

        lsp_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lsp_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
        )

        require('luasnip.loaders.from_vscode').lazy_load()

        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            sources = {
                {name = 'path'},
                {name = 'nvim_lsp', keyword_length = 1},
                {name = 'buffer', keyword_length = 3},
                {name = 'luasnip', keyword_length = 2},
            },
            mapping = {
                -- ['<esc>'] = cmp.mapping.abort(),
                ['<c-j>'] = cmp.mapping.select_next_item(),
                ['<c-k>'] = cmp.mapping.select_prev_item(),
                ['<c-l>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.mapping.confirm({ select = true })()
                    elseif luasnip.jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { 'i', 's' })
            },
        })
    end
}
