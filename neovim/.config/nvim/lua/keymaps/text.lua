-- move lines
vim.keymap.set('v', '<c-j>', ':m \'>+1<cr>gv=gv', { desc = 'Move line down' })
vim.keymap.set('v', '<c-k>', ':m \'<-2<cr>gv=gv', { desc = 'Move line up' })

-- add lines
vim.keymap.set('n', '<space>o', 'mzo<esc>`z', { desc = 'Add line below' })
vim.keymap.set('n', '<space>O', 'mzO<esc>`z', { desc = 'Add line above' })

-- keep cursor still after visual mode
vim.keymap.set('x', 'y', 'ygv<esc>', { desc = 'Keep cursor when copying visual selection' })
