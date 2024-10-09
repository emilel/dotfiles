return {
    'mfussenegger/nvim-lint',
    config = function()
        local linters_by_ft = {
            python = { 'mypy', 'pylint' }
        }

        local function filter_available_linters(linters)
            local available_linters = {}
            for _, linter in ipairs(linters) do
                if vim.fn.executable(linter) == 1 then
                    table.insert(available_linters, linter)
                end
            end
            return available_linters
        end

        for ft, linters in pairs(linters_by_ft) do
            linters_by_ft[ft] = filter_available_linters(linters)
        end

        require('lint').linters_by_ft = linters_by_ft

        vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
            callback = function()
                require("lint").try_lint()
            end,
        })
    end
}
