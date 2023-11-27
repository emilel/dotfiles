local run = require('functions.run')

vim.keymap.set('n', '<space>z', 'gqip', { desc = 'Format paragraph', buffer = true })

vim.keymap.set('n', '<cr>r', function()
    run.send_check('latexmk -cd -pdf %; latexmk -cd -c %')
end, { desc = 'Compile document', buffer = true })

vim.keymap.set('n', '<cr>o', function()
    local compiled_path = string.gsub(vim.api.nvim_buf_get_name(0), '.tex', '.pdf')
    run.open(compiled_path)
end, { desc = 'Open document', buffer = true })
