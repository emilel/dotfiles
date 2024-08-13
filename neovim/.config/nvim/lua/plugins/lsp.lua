return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
        {
            'stevearc/conform.nvim',
            opts = {
                formatters_by_ft = {
                    lua = {},
                }
            },
        },
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup()

        require("mason-lspconfig").setup_handlers({
            function(server_name)
                require("lspconfig")[server_name].setup {}
            end,

            ['lua_ls'] = function()
                require('lspconfig').lua_ls.setup({
                    on_init = function(client)
                        local path = client.workspace_folders[1].name
                        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                            return
                        end

                        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                            runtime = {
                                version = 'LuaJIT'
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME
                                }
                            }
                        })
                    end,
                    settings = {
                        Lua = {}
                    }
                })
            end
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'Language server protocol',
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
                vim.keymap.set('n', ',z', function()
                        require('conform').format({ lsp_fallback = true })
                    end,
                    { desc = 'Format buffer' })
                vim.keymap.set('x', ',z', function()
                        require('conform').format({ lsp_fallback = true })
                    end,
                    { desc = 'Format selection' })
            end
        })
    end,
}
