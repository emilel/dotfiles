return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path'
    },
    config = function()
        local lspconfig = require('lspconfig')
        local lsp_defaults = lspconfig.util.default_config

        lsp_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lsp_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
        )

        local cmp = require('cmp')

        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body)
                end,
            },
            sources = {
                { name = 'nvim_lsp', keyword_length = 1 },
                { name = 'buffer',   keyword_length = 100 },
                { name = 'path' },
            },
            mapping = {
                ['<c-h>'] = cmp.mapping(function()
                    if vim.snippet.active({ direction = -1 }) then
                        vim.snippet.jump(-1)
                    end
                end),
                ['<c-j>'] = cmp.mapping.select_next_item(),
                ['<c-k>'] = cmp.mapping.select_prev_item(),
                ['<c-l>'] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.confirm()
                    elseif vim.snippet.active({ direction = 1 }) then
                        vim.snippet.jump(1)
                    else
                        cmp.complete()
                    end
                end),
            },
            completion = {
                autocomplete = false
            }
        })
    end
}
