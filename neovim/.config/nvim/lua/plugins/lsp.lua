return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'williamboman/mason-lspconfig.nvim' },
        { 'williamboman/mason.nvim' },
    },
    ft = { 'tex' },
    lazy = true,
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup()

        local lspconfig = require('lspconfig')
        local get_servers = require('mason-lspconfig').get_installed_servers
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        for _, server_name in ipairs(get_servers()) do
            lspconfig[server_name].setup({
                capabilities = lsp_capabilities,
            })
        end

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function()
                vim.keymap.set('n', 'K', vim.lsp.buf.hover,
                    { desc = 'Hover documentation', buffer = true }
                )
                vim.keymap.set('n', ',gd', vim.lsp.buf.definition,
                    { desc = 'Go to definition', buffer = true }
                )
                vim.keymap.set('n', ',gr', vim.lsp.buf.references,
                    { desc = 'Find references', buffer = true }
                )
                vim.keymap.set('n', ',rn', vim.lsp.buf.rename,
                    { desc = 'Rename symbol', buffer = true }
                )
                vim.keymap.set('n', ',f', vim.diagnostic.open_float,
                    { desc = 'Open diagnostic' }
                )
                vim.keymap.set('n', ',z', vim.lsp.buf.format,
                    { desc = 'Format file' }
                )
            end
        })
    end
}
