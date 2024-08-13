return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'williamboman/mason-lspconfig.nvim' },
        { 'williamboman/mason.nvim' },
        { 'nvim-treesitter/nvim-treesitter-textobjects' },
        {
            'stevearc/conform.nvim',
            opts = {
                formatters_by_ft = {
                    sh = { 'shfmt', 'beautysh' },
                    bash = { 'shfmt', 'beautysh' },
                    python = { 'black', 'isort' },
                    rust = { 'rustfmt' }
                }
            },
        },
    },
    ft = { 'tex', 'c', 'python', 'cpp', 'rust' },
    cmd = { 'Mason' },
    lazy = true,
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup()

        local lspconfig = require('lspconfig')
        local get_servers = require('mason-lspconfig').get_installed_servers()
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        local server_specific_settings = {
            lua_ls = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' },
                    },
                },
            },
        }

        for _, server_name in ipairs(get_servers) do
            local server_settings = server_specific_settings[server_name] or {}

            lspconfig[server_name].setup({
                capabilities = lsp_capabilities,
                settings = server_settings,
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
                vim.keymap.set('n', ',ca', vim.lsp.buf.code_action, { desc = 'Code action' })
                vim.keymap.set('n', ',z', function() require('conform').format({ lsp_fallback = true }) end,
                    { desc = 'Format buffer' })
                vim.keymap.set('x', ',z', function() require('conform').format({ lsp_fallback = true }) end,
                    { desc = 'Format selection' })
            end
        })
    end
}
