-- move lines
vim.keymap.set('v', '<c-j>', ':m \'>+1<cr>gv=gv', { desc = 'Move line down' })
vim.keymap.set('v', '<c-k>', ':m \'<-2<cr>gv=gv', { desc = 'Move line up' })

-- add lines
vim.keymap.set('n', '<space>o', 'myo<esc>`y', { desc = 'Add line below' })
vim.keymap.set('n', '<space>O', 'myO<esc>`y', { desc = 'Add line above' })

-- keep cursor still after visual mode
vim.keymap.set('x', 'y', 'ygv<esc>', { desc = 'Keep cursor when copying visual selection' })

-- format paragraph length
vim.keymap.set('n', '<space>z', 'mygwap`y', { desc = 'Format paragraph' })

-- don't copy when deleting or changing
vim.keymap.set({ 'n', 'x' }, '<space>d', '"_d', { desc = 'Delete without copying' })
vim.keymap.set({ 'n', 'x' }, '<space>c', '"_c', { desc = 'Change without copying' })

-- don't copy when starting insert mode on a character
vim.keymap.set('n', 's', '"_s', { desc = 'Don\'t copy letter when pressing `s`' })
