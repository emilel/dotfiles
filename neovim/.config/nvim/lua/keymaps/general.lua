-- save file
vim.keymap.set('n', '<c-space>', '<cmd>write<cr>', { desc = 'Save file' })

-- close buffer
vim.keymap.set('n', '<space>c', '<cmd>bd<cr>', { desc = 'Close buffer' })

-- close other windows
vim.keymap.set('n', '<space>F>', '<cmd>only<cr>', { desc = 'Close other windows' })

-- focus window
vim.keymap.set('n', '<space>h', '<cmd>wincmd h<cr>', { desc = 'Focus window to the left' })
vim.keymap.set('n', '<space>j', '<cmd>wincmd j<cr>', { desc = 'Focus window below' })
vim.keymap.set('n', '<space>k', '<cmd>wincmd k<cr>', { desc = 'Focus window above' })
vim.keymap.set('n', '<space>l', '<cmd>wincmd l<cr>', { desc = 'Focus window to the right' })

-- close Neovim
vim.keymap.set('n', '<space>q', '<cmd>q<cr>', { desc = 'Close Neovim' })
vim.keymap.set('n', '<space>Q', '<cmd>q!<cr>', { desc = 'Force close Neovim' })

-- limit text width
vim.opt.textwidth = 80

-- move cursor
vim.keymap.set('i', '<c-j>', '<down>', { desc = 'Move cursor down' })
vim.keymap.set('i', '<c-k>', '<up>', { desc = 'Move cursor up' })

-- keep visual selection when indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Keep visual selection when indenting' })
vim.keymap.set('v', '>', '>gv', { desc = 'Keep visual selection when indenting' })
