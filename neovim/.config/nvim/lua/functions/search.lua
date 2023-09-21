local search = {}

search.without_jumping = function()
    vim.ui.input(
        { prompt = '¿' },
        function(term)
            if term == nil then
                return
            end

            vim.cmd('set hlsearch | let @/ = "' .. term .. '"')
        end)
end

return search
