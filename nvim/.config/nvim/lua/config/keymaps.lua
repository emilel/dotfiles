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
vim.keymap.set('n', '<space>e', 'my<cmd>e<cr>`y', { desc = 'Reread file' })
vim.keymap.set('n', '<c-.>', '<cmd>bn<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<c-,>', '<cmd>bp<cr>', { desc = 'Previous buffer' })

-- copy
vim.keymap.set('v', '<space>p', '"_dP', { desc = 'Dont copy when pasting' })
vim.keymap.set({ 'v', 'n' }, '<space>d', '"_d', { desc = 'Don\'t copy when deleting' })
vim.keymap.set('v', '<space>c', '"_da', { desc = 'Don\'t copy when changing' })
vim.keymap.set('n', 'x', '"_x', { desc = 'Don\'t copy when deleting' })
vim.keymap.set('n', 'X', 'x', { desc = 'Do copy when deleting' })
vim.keymap.set('n', 'gp', '`[v`]', { desc = 'Select pasted text' })
vim.keymap.set('v', 'y', '<esc>mygvy`y', { desc = 'Keep location when copying in visual mode' })
vim.keymap.set('n', '<space>yy', '^y$', { desc = 'Copy content on line' })
vim.keymap.set('v', 'Y',
	'<esc>mugv"yy:call setreg("+", getreg("+", 1, 1) + split("<c-r>y", "\\r"), getregtype("+"))<cr>`u',
	{ desc = 'Append selection to + register', silent = true })
vim.keymap.set('n', '<space>yp', '<cmd>let @+ = fnamemodify(expand("%"), ":~:.")<cr>', { desc = 'Copy relative path' })
vim.keymap.set('n', '<space>yP', '<cmd>let @+ = expand("%:p")<cr>', { desc = 'Copy absolute path' })
vim.keymap.set('n', '<space>yb', '<cmd>let @+ = system("git rev-parse --abbrev-ref HEAD | tr -d \\"\\n\\"")<cr>')

-- visual
vim.keymap.set('v', '*', '<esc>mugv"yy/\\<<c-r>y\\><cr>`u', { desc = 'Search for exact string' })
vim.keymap.set('v', '/', '<esc>mugv"yy/<c-r>y<cr>')
vim.keymap.set('n', '\\', '<cmd>nohlsearch<cr>', { desc = 'Don\'t highlight search matches' })
vim.keymap.set('n', '<space>v', '^v$h', { desc = 'Select content on line' })
vim.keymap.set('n', '<space>V', 'GVgg', { desc = 'Select content in file' })
vim.keymap.set('n', '<space>f', '<cmd>only<cr>', { desc = 'Make full screen' })
vim.keymap.set('n', '=h', '^vf=be', { desc = 'Select LHS in assignment' })
vim.keymap.set('n', '=l', '0f=wv$h', { desc = 'Select HHS in assignment' })

-- search and replace
vim.keymap.set('n', '?', ':set hlsearch | let @/ = ""<left>',
	{ desc = 'Search but do not jump' })
vim.keymap.set('n', '<space>?', ':set hlsearch | let @/ = "\\\\<\\\\>"<left><left><left><left>',
	{ desc = 'Search for word but do not jump' })
vim.keymap.set('x', 'r',
	'"hymu:s/<C-R>=escape(@h,\'/\\\')<CR>//g | :noh | :normal `u<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>',
	{ desc = 'Replace selection on current line' })
vim.keymap.set('v', '<space>R', '"hy:%s/<C-R>=escape(@h,\'/\\\')<CR>//gc<left><left><left>',
	{ desc = 'Replace in whole file' })
vim.keymap.set('v', '<space>r', ':s/\\%V<c-r>e//g<left><left>', { desc = 'Replace in selection' })
vim.keymap.set('v', 'D', 'ygvV"_d', { desc = 'Copy selection and delete line' })


-- movement
vim.keymap.set('v', '<c-j>', ':m \'>+1<cr>gv', { desc = 'Move line down' })
vim.keymap.set('v', '<c-k>', ':m \'<-2<cr>gv', { desc = 'Move line up' })
vim.keymap.set('v', '\'', '"ey`<mq`>mw', { desc = 'Mark word' })
vim.keymap.set('v', 'm', '"ey`<mr`>mt`qv`w"ep`rv`tp', { desc = 'Switch with marked word' })
vim.keymap.set('v', 'L', '$h', { desc = 'Select until end of line' })
vim.keymap.set('n', '<space>o', 'myo<esc>`y', { desc = 'Create line below' })
vim.keymap.set('n', '<space>O', 'myO<esc>`y', { desc = 'Create line above' })
vim.keymap.set('v', '<', '<gv', { desc = 'Keep visual selection when indenting' })
vim.keymap.set('v', '>', '>gv', { desc = 'Keep visual selection when indenting' })
vim.keymap.set('v', '<space>o', '<esc>my`>o<esc>`ygv', { desc = 'Add line below' })
vim.keymap.set('v', '<space>O', '<esc>my`<O<esc>`ygv', { desc = 'Add line above' })


-- quickfix
vim.keymap.set('n', '<c-h>', '<cmd>cprev<cr>', { desc = 'Previous item in the quickfix list' })
vim.keymap.set('n', '<c-l>', '<cmd>cnext<cr>', { desc = 'Next item in the quickfix list' })
vim.keymap.set('n', '<space><c-h>', '<cmd>copen<cr><cmd>cfirst<cr>', { desc = 'Open quickfix list' })
vim.keymap.set('n', '<c-q>', '<cmd>cclose<cr>', { desc = 'Close quickfix list' })

-- run command again
vim.keymap.set('n', '<bs><space>', '<cmd>silent !tmux send-keys -t "run.bottom-right" Up Enter<cr>',
	{ desc = 'Run command again' })
vim.keymap.set('n', '<bs><bs><space>', '<cmd>silent !tmux send-keys -t "run.1" C-d Up Enter<cr>',
	{ desc = 'Run command again after pressing <c-d>' })

-- change behaviour
vim.keymap.set('n', '~', '~h', { desc = 'Don\'t go to next letter when capitalizing' })
vim.keymap.set('n', '*', '<cmd>let view = winsaveview()<cr>*``<cmd>call winrestview(view)<cr>',
	{ desc = 'Don\'t jump on star' })

-- my functions
vim.keymap.set('i', '<c-a>', require("config.functions").insert_path,
	{ desc = 'Insert path' })
vim.keymap.set('n', '<space>J', require('config.functions').join, { desc = 'Join + register' })
vim.keymap.set('n', '<space>sN', require('config.functions').list_snips, { desc = 'List snippets' })
vim.keymap.set('n', '<space>F', 'my<cmd>%bd|e#<cr>`y', { desc = 'Delete all other buffers' })