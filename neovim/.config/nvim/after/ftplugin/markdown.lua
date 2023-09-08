vim.keymap.set('n', '<space>z', 'gqip', { desc = 'Format paragraph', buffer = true })
vim.keymap.set('n', '<space>Z', 'gggqG', { desc = 'Format file', buffer = true })

vim.keymap.set('n', '<cr>l', require('functions.run').compile_letter, { desc = 'Compile letter' })
vim.keymap.set('n', '<cr>o', require('functions.run').open_compiled_letter, { desc = 'Open compile letter' })
