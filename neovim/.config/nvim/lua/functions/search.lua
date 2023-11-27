local globals = require('globals')
local search = {}

search.without_jumping = function()
    vim.ui.input(
        { prompt = '¿' },
        function(term)
            if term == nil then
                return
            end

            vim.o.hlsearch = true
            vim.fn.setreg('/', term)
        end)
end

search.escape = function(arg)
    local escaped = vim.fn.escape(arg, globals.escape_symbols)
    vim.fn.setreg('/', escaped)
    vim.o.hlsearch = true
end

search.current = function()
    vim.api.nvim_feedkeys('"yyiw', 'x', true)
    local escaped = vim.fn.escape(vim.fn.getreg('y'), globals.escape_symbols)
    print(escaped)
    vim.o.hlsearch = true
    vim.fn.setreg('/', escaped)
end

return search
