return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'neovim/nvim-lspconfig' },
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
            sources = {
                { name = 'nvim_lsp', keyword_length = 1 },
            },
            mapping = {
                ['<c-j>'] = cmp.mapping.select_next_item(),
                ['<c-k>'] = cmp.mapping.select_prev_item(),
                ['<c-l>'] = cmp.mapping.confirm()
            },
        })
    end
}
