local yank = require('functions.yank')
local search = require('functions.search')
local temp = require('functions.temp')
local run = require('functions.run')

-- # general

-- ## close editor

vim.keymap.set('n', '<space>q', '<cmd>q<cr>', { desc = 'Quit neovim' })
vim.keymap.set('n', '<space>Q', '<cmd>q!<cr>', { desc = 'Force quit neovim' })

-- # buffers

-- ## save file

vim.keymap.set('n', '<c-space>', '<cmd>write<cr>', { desc = 'Save file' })

-- ## close buffer

vim.keymap.set('n', '<space>C', '<cmd>bdelete<cr>', { desc = 'Close buffer' })

-- ## switch buffer

vim.keymap.set('n', '<tab>', '<cmd>bnext<cr>', { desc = 'Go to next buffer' })
vim.keymap.set('n', '<s-tab>', '<cmd>bprev<cr>', { desc = 'Go to next buffer' })

-- # windows

-- ## select window

vim.keymap.set('n', '<space>h', '<cmd>wincmd h<cr>', { desc = 'Select window to the left' })
vim.keymap.set('n', '<space>j', '<cmd>wincmd j<cr>', { desc = 'Select window below' })
vim.keymap.set('n', '<space>k', '<cmd>wincmd k<cr>', { desc = 'Select window above' })
vim.keymap.set('n', '<space>l', '<cmd>wincmd l<cr>', { desc = 'Select window to the right' })

-- ## close other windows

vim.keymap.set('n', '<c-q>', '<cmd>only<cr>', { desc = 'Close other windows' })

-- # movement

-- ## to to previous word

vim.keymap.set({ 'n', 'x' }, 'z', 'ge', { desc = 'Go to end of previous word' })

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

-- ## swap text

vim.keymap.set('x', "\'", require('functions.swap').mark, { desc = 'Mark text for swapping' })
vim.keymap.set('x', "m", require('functions.swap').swap, { desc = 'Swap with marked text' })

-- ## replace text

vim.keymap.set('x', "<space>\'", require('functions.swap').prepare_replace, { desc = 'Mark text for replace' })
vim.keymap.set('x', "<cr>", require('functions.swap').do_replace, { desc = 'Do replace in selection' })

-- ## changing settings

vim.keymap.set('n', '<space>sf', require('functions.settings').toggle_autoformat, { desc = 'Toggle autoformat' })

-- ## terminal mode

vim.keymap.set('t', '<esc>', '<c-\\><c-n>', { desc = 'Go to normal mode in terminal' })

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

-- ## select content on line

vim.keymap.set('n', '<space>v', '^v$h', { desc = 'Select line' })

-- ## select entire file

vim.keymap.set('n', '<space>V', 'ggVG', { desc = 'Select entire file' })

-- # yanking

-- ## edit + register content

vim.keymap.set('n', '<space>+', function()
    temp.edit_register(); vim.cmd('SaveToCopy')
end, { desc = 'Edit + register content' })

-- ## don't copy when deleting

vim.keymap.set({ 'n', 'x' }, '<space>d', '"_d', { desc = 'Delete without copying' })

-- ## don't copy when changing

vim.keymap.set({ 'n', 'x' }, '<space>c', '"_c', { desc = 'Change without copying' })

-- ## don't copy when deleting a character

vim.keymap.set({ 'n', 'x' }, 'x', '"_x', { desc = 'Don\'t copy when deleting one character' })

-- ## delete previous character

vim.keymap.set('n', 'X', 'h"_x', { desc = 'Delete previous character' })

-- ## copy entire file

vim.keymap.set('n', '<space>yf', yank.file, { desc = 'Copy entire file' })

-- ## edit selection before yanking

vim.keymap.set('x', '<space>ye', function()
    temp.selection(); vim.cmd('SaveToCopy')
end, { desc = 'Edit selection before copying' })

-- ## edit file before copying

vim.keymap.set('n', '<space>ye', function()
    temp.file(); vim.cmd('SaveToCopy')
end, { desc = 'Edit file before copying' })

-- ## copy entire file and trim

vim.keymap.set('n', '<space>yt', function()
    yank.file(); yank.remove_hard_line_breaks()
end, { desc = 'Copy entire file and trim' })

-- ## copy selection and trim

vim.keymap.set('x', '<space>yt', function()
    vim.api.nvim_feedkeys('y', 'x', true); yank.remove_hard_line_breaks()
end, { desc = 'Copy entire file and trim' })

-- ## copy file path

vim.keymap.set('n', '<space>yp', yank.relative_path, { desc = 'Copy relative file path' })
vim.keymap.set('n', '<space>yP', yank.full_path, { desc = 'Copy full file path' })

-- # search

-- ## highlight search term without jumping

vim.keymap.set('n', '?', search.without_jumping, { desc = 'Search without jumping' })

-- ## don't jump with star

vim.keymap.set('n', '*', search.current, { desc = 'Search for current word' })

-- # search for selection

vim.keymap.set('x', '/', '"yy:lua require("functions.search").escape("<c-r>y")<cr>',
    { desc = 'Search for selection', silent = true })

-- # search for selected word

vim.keymap.set('x', '*', '"yy:lua require("functions.search").escape("\\\\<<c-r>y\\\\>")<cr>',
    { desc = 'Search for selected word', silent = true })

-- # replace in selection

vim.keymap.set('v', '<space>r', ':s/\\%V<c-r>e//g<left><left>', { desc = 'Replace in selection' })

-- # replace in file

vim.keymap.set('v', '<space>R', '"hy:%s/\\<<C-R>=escape(@h,\'/\\\')<CR>\\>//gc<left><left><left>',
    { desc = 'Replace in whole file' })

-- # replace on line

vim.keymap.set('x', 'r',
    '"hymu:s/<C-R>=escape(@h,\'/\\\')<CR>//g | :noh | :normal `u<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>',
    { desc = 'Replace selection on current line' })

-- # save in location list

vim.keymap.set('n', '\'', 'm\'', { desc = 'Set jump list location' })

-- # run

-- ## cancel

vim.keymap.set('n', '<cr>c', run.interrupt, { desc = 'Send interruption to run pane' })
