vim.keymap.set('n', '<space>z', 'gqip', { desc = 'Format paragraph', buffer = true })
vim.keymap.set('n', '<space>Z', 'mzgggqG<cmd>silent %s/\\s\\+$//e<cr><cmd>noh<cr>`z', { desc = 'Format file', buffer = true })

vim.keymap.set('n', '<cr>l', require('functions.run').compile_letter, { desc = 'Compile letter' })
vim.keymap.set('n', '<cr>o', require('functions.run').open_compiled_letter, { desc = 'Open compile letter' })

vim.opt_local.formatoptions = "nq"
