local utils = require('utils')

require('config.lazy')

utils.require_directory('keymaps')
utils.require_directory('settings')

vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        local clients = vim.lsp.get_clients()

        for _, client in ipairs(clients) do
            local id = client.id

            vim.lsp.completion.enable(true, id, 1, { autotrigger = true })

            return
        end
    end,

})
