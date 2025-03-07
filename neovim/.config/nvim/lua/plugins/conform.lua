vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin' .. ':' .. vim.env.PATH

return {
    'stevearc/conform.nvim',
    config = function()
        require('conform').setup({
            formatters_by_ft = {
                python = { 'black', 'isort' },
                zsh = { 'beautysh' },
                sh = { 'beautysh' },
                bash = { 'beautysh' },
            }
        })
    end
}
