return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()

    require("mason-lspconfig").setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({})
      end,

      ['lua_ls'] = function()
        require('lspconfig').lua_ls.setup({
          on_init = function(client)
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
      end,

      ['clangd'] = function()
        require("lspconfig").clangd.setup({
          cmd = { "clangd", "--background-index" },
        })
      end,
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'Language server protocol',
      callback = function()
        vim.keymap.set('n', 'K', vim.lsp.buf.hover,
          { desc = 'Hover documentation', buffer = true }
        )
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
          { desc = 'Go to definition', buffer = true }
        )
        vim.keymap.set('n', '\\f', vim.diagnostic.open_float,
          { desc = 'Open diagnostic' }
        )
        vim.keymap.set({ 'n', 'x' }, '\\z', function()
            require('conform').format({ lsp_fallback = true })
          end,
          { desc = 'Format buffer' })
        vim.keymap.set({ 'n', 'x' }, '\\l', '<cmd>LspRestart<cr>',
          { desc = 'Restart LSP server' })
      end
    })
  end,
}
