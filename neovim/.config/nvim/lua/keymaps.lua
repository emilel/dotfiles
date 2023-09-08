-- # general

-- ## save file

vim.keymap.set('n', '<c-space>', '<cmd>write<cr>', { desc = 'Save file' })

-- ## close buffer

vim.keymap.set('n', '<space>c', '<cmd>bdelete<cr>', { desc = 'Close buffer' })
vim.keymap.set('n', '<space>C', '<cmd>bdelete!<cr>', { desc = 'Force close buffer' })

-- ## close editor

vim.keymap.set('n', '<space>q', '<cmd>q<cr>', { desc = 'Quit neovim' })
vim.keymap.set('n', '<space>Q', '<cmd>q!<cr>', { desc = 'Force quit neovim' })

-- # windows

vim.keymap.set('n', '<space>h', '<cmd>wincmd h<cr>', { desc = 'Select window to the left' })
vim.keymap.set('n', '<space>j', '<cmd>wincmd j<cr>', { desc = 'Select window below' })
vim.keymap.set('n', '<space>k', '<cmd>wincmd k<cr>', { desc = 'Select window above' })
vim.keymap.set('n', '<space>l', '<cmd>wincmd l<cr>', { desc = 'Select window to the right' })

-- # editing text

-- ## execute normal mode commands on block

vim.keymap.set('x', '<space>n', ':%norm ', { desc = 'Execute normal mode commands on every line' })

-- ## move lines

vim.keymap.set('v', '<c-j>', ':m \'>+1<cr>gv=gv', { desc = 'Move line down' })
vim.keymap.set('v', '<c-k>', ':m \'<-2<cr>gv=gv', { desc = 'Move line up' })

-- ## remove lines

vim.keymap.set('v', '<space>J', '<esc>`>j"_ddgv', { desc = 'Remove line below' })
vim.keymap.set('v', '<space>K', '<esc>`<k"_ddgv', { desc = 'Remove line above' })

-- ## add lines

vim.keymap.set('n', '<space>o', 'mzo<esc>`z', { desc = 'Create line below' })
vim.keymap.set('n', '<space>O', 'mzO<esc>`z', { desc = 'Create line above' })
vim.keymap.set('v', '<space>o', '<esc>my`>o<esc>`ygv', { desc = 'Add line below' })
vim.keymap.set('v', '<space>O', '<esc>my`<O<esc>`ygv', { desc = 'Add line above' })

-- # changing settings

vim.keymap.set('n', '<space>sf', require('functions.settings').toggle_autoformat, { desc = 'Toggle autoformat' })

-- # terminal mode

vim.keymap.set('t', '<esc>', '<c-\\><c-n>', { desc = 'Go to normal mode in terminal' })
vim.keymap.set('t', '<space>c', '<cmd>bdelete!<cr>', { desc = 'Exit terminal mode' })

-- # visual mode

-- ## keep location when copying

vim.keymap.set('x', 'y', 'ygv<esc>', { desc = 'Keep selection when copying visual selection' })

-- ## go to end of line

vim.keymap.set('x', 'L', '$h', { desc = 'Go to end of line' })

-- ## execute command for every line

vim.keymap.set('x', '<space>n', ':%norm ', { desc = 'Execute normal mode command for every line' })

-- ## select pasted text

vim.keymap.set('n', 'gp', '`[v`]', { desc = 'Select pasted text' })

-- ## don't lose selection during indentation

vim.keymap.set('v', '<', '<gv', { desc = 'Keep visual selection when indenting' })
vim.keymap.set('v', '>', '>gv', { desc = 'Keep visual selection when indenting' })

-- ## select entire file

vim.keymap.set('n', '<space>V', 'ggVG', { desc = 'Select entire file' })

-- # yanking

-- ## don't copy when deleting

vim.keymap.set({ 'n', 'x' }, '<space>d', '"_d', { desc = 'Delete without copying' })

-- ## don't copy when deleting a character

vim.keymap.set({ 'n', 'x' }, 'x', '"_x', { desc = 'Don\'t copy when deleting one character' })

-- ## delete previous character

vim.keymap.set('n', 'X', 'h"_x', { desc = 'Copy previous character' })

-- ## copy entire file

vim.keymap.set('n', '<space>yf', 'mzggyG`z', { desc = 'Copy entire file' })

-- ## copy file path

vim.keymap.set('n', '<space>yp', require('functions.yank').path, { desc = 'Copy file path' })
vim.keymap.set('n', '<space>yP', require('functions.yank').full_path, { desc = 'Copy full file path' })
