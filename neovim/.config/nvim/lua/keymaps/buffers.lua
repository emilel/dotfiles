-- save file
vim.keymap.set('n', '<c-space>', '<cmd>write<cr>', { desc = 'Save file' })

-- close buffer
vim.keymap.set('n', '<space>c', '<cmd>bd<cr>', { desc = 'Close buffer' })

-- focus window
vim.keymap.set('n', '<space>h', '<cmd>wincmd h<cr>', { desc = 'Select window to the left' })
vim.keymap.set('n', '<space>j', '<cmd>wincmd j<cr>', { desc = 'Select window below' })
vim.keymap.set('n', '<space>k', '<cmd>wincmd k<cr>', { desc = 'Select window above' })
vim.keymap.set('n', '<space>l', '<cmd>wincmd l<cr>', { desc = 'Select window to the right' })

-- close Neovim
vim.keymap.set('n', '<space>q', '<cmd>q<cr>', { desc = 'Close Neovim' })
vim.keymap.set('n', '<space>Q', '<cmd>q!<cr>', { desc = 'Force close Neovim' })
