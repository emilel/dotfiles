-- Remap for dealing with word wrap
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- window movement
vim.keymap.set('n', '<space>h', '<cmd>wincmd h<cr>', { desc = "Window left" })
vim.keymap.set('n', '<space>j', '<cmd>wincmd j<cr>', { desc = "Window down" })
vim.keymap.set('n', '<space>k', '<cmd>wincmd k<cr>', { desc = "Window up" })
vim.keymap.set('n', '<space>l', '<cmd>wincmd l<cr>', { desc = "Window right" })
vim.keymap.set('n', '<space>c', '<cmd>q<cr>', { desc = "Close window" })
vim.keymap.set('n', '<space>C', '<cmd>q!<cr>', { desc = "Force close window" })
vim.keymap.set('n', '<space>q', '<cmd>qa<cr>', { desc = "Close all windows" })
vim.keymap.set('n', '<space>Q', '<cmd>qa!<cr>', { desc = "Force close all windows" })
vim.keymap.set('n', '<c-space>', '<cmd>w<cr>', { desc = "Save file" })

-- copy
vim.keymap.set('v', '<space>p', '"_dP', { desc = 'Dont copy when pasting' })
vim.keymap.set('v', '<space>d', '"_d', { desc = 'Don\'t copy when deleting' })
vim.keymap.set('n', '<space>d', '"_d', { desc = 'Don\'t copy when deleting' })
vim.keymap.set('n', 'x', '"_x', { desc = 'Don\'t copy when deleting' })
vim.keymap.set('n', 'X', 'x', { desc = 'Do copy when deleting' })
vim.keymap.set('n', 'gp', '`[v`]', { desc = 'Select pasted text' })
vim.keymap.set('v', 'y', '<esc>mygvy`y', { desc = 'Keep location when copying in visual mode' })
vim.keymap.set('n', '<space>y', '^y$', { desc = 'Copy content on line' })

-- :let view = winsaveview()
--:call winrestview(view)<cr>
-- visual
vim.keymap.set({ 'n', 'v' }, '*', '<cmd>let view = winsaveview()<cr>*``<cmd>call winrestview(view)<cr>',
{ desc = 'Don\'t jump on star' })
vim.keymap.set('n', '\\', '<cmd>nohlsearch<cr>', { desc = 'Don\'t highlight search matches' })
vim.keymap.set('n', '<space>v', '^v$h', { desc = 'Select content on line' })
vim.keymap.set('n', '<space>f', '<cmd>only<cr>', { desc = 'Make full screen' })

-- search and replace
vim.keymap.set('n', '?', ':set hlsearch | let @/ = ""<left>', { desc = 'Search but do not jump' })
vim.keymap.set('x', 'r',
	'"hy:s/<C-R>=escape(@h,\'/\\\')<CR>//g | :noh<left><left><left><left><left><left><left><left><left>',
	{ desc = 'Replace selection on current line' })
vim.keymap.set('v', '<space>R', '"hy:%s/<C-R>=escape(@h,\'/\\\')<CR>//gc<left><left><left>',
	{ desc = 'Replace in whole file' })
vim.keymap.set('v', '<space>r', ':s/\\%V<c-r>e//g<left><left>', { desc = 'Replace in selection' })

-- movement
vim.keymap.set('v', '<c-j>', ':m \'>+1<cr>==gv', { desc = 'Move line down' })
vim.keymap.set('v', '<c-k>', ':m \'<-2<cr>==gv', { desc = 'Move line up' })
vim.keymap.set('v', '\'', '"ey`<mq`>mw', { desc = 'Mark word' })
vim.keymap.set('v', 'm', '"ey`<mr`>mt`qv`w"ep`rv`tp', { desc = 'Switch with marked word' })
vim.keymap.set('v', 'L', '$h', { desc = 'Select until end of line' })
vim.keymap.set('n', '<space>o', 'myo<esc>`y', { desc = 'Create line below' })
vim.keymap.set('n', '<space>O', 'myO<esc>`y', { desc = 'Create line above' })
vim.keymap.set('v', '<', '<gv', { desc = 'Keep visual selection when indenting' })
vim.keymap.set('v', '>', '>gv', { desc = 'Keep visual selection when indenting' })

-- quickfix
vim.keymap.set('n', '<c-h>', '<cmd>cprev<cr>', { desc = 'Previous item in the quickfix list' })
vim.keymap.set('n', '<c-l>', '<cmd>cnext<cr>', { desc = 'Next item in the quickfix list' })
vim.keymap.set('n', '<space><c-h>', '<cmd>copen<cr><cmd>cfirst<cr>', { desc = 'Open quickfix list' })
vim.keymap.set('n', '<c-q>', '<cmd>cclose<cr>', { desc = 'Close quickfix list' })

-- run command again
vim.keymap.set('n', '<bs><space>', '<cmd>silent !tmux send-keys -t "run.1" C-c Up Up Enter<cr>')
vim.keymap.set('n', '<bs><bs><space>', '<cmd>silent !tmux send-keys -t "run.1" C-d Up Enter<cr>')

-- change things
vim.keymap.set('n', '~', '~h', { desc = 'Don\'t go to next letter when capitalizing' })
