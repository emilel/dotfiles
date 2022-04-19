-- HELPERS
local nmap = require('helpers').nmap
local imap = require('helpers').imap
local vmap = require('helpers').vmap

-- MISC

-- reload vimrc
nmap('<f1>', 'source $MYVIMRC')

-- save file
nmap('<c-space>', '<cmd>w<cr>', { noremap = true, silent = false })
vmap('<c-space>', '<esc><cmd>w<cr>gv', { noremap = true, silent = false })

-- WINDOW MOVEMENT

-- close window
nmap('<space>c', ':q<cr>')

-- close all but currently focused
nmap('<c-q>', '<cmd>only<cr>')

-- up, down etc
nmap('<space>h', '<cmd>wincmd h<cr>')
nmap('<space>j', '<cmd>wincmd j<cr>')
nmap('<space>k', '<cmd>wincmd k<cr>')
nmap('<space>l', '<cmd>wincmd l<cr>')


-- FILE NAVIGATION

-- copy relative path
nmap('<space>yy', '<cmd>let @+ = fnamemodify(expand("%"), ":~:.")<cr>')

-- copy full path
nmap('<space>YY', '<cmd>let @+ = expand("%:p")<cr>')

-- EDITOR COMMANDS

-- fold
nmap('<cr>', 'za')

-- toggle fold all
nmap('<backspace>', '&foldlevel ? "zM" :"zR"')

-- prev/next in quickfix
nmap('<c-j>', '<cmd>cnext<cr>')
nmap('<c-k>', '<cmd>cprev<cr>')

-- format paragraph
nmap('<space>,', 'gwap')

-- add to jump list
nmap('\'', 'm\'')

-- search with perl
nmap('/', '/\\v')

-- select pasted text
nmap('gp', '`[v`]')

-- delete row above or below
vmap('<space>J', '<esc>j"_ddgv')
vmap('<space>K', '<esc>k"_ddgv')

-- add row above or below
vmap('<space>j', '<esc>o<esc>gv')
vmap('<space>k', '<esc>O<esc>gv')

-- move selection
vmap('<c-j>', ':m \'>+1<CR>gv')
vmap('<c-k>', ':m \'<-2<CR>gv')

-- insert row
nmap('<space>O', 'muO<esc>`u')
nmap('<space>o', 'muo<esc>`u')
vmap('<space>O', '<esc>`<O<esc>gv')
vmap('<space>o', '<esc>`>o<esc>gv')

-- undo in visual
vmap('u', '<esc>ugv')
vmap('<c-r>', '<esc><c-r>gv')

-- keep selection when indenting
vmap('<', '<gv')
vmap('>', '>gv')


-- COPY

-- don't copy when prepending space
vmap('<space>d', '"_d')
vmap('<space>d', '"_d')
vmap('<leader>D', '"_D')

-- copy to end of line
nmap('Y', 'y$')

-- SEARCH

-- search for selection in file
vmap('/', '"hy/\\V<C-R>=escape(@h,\'/\\\')<CR><CR>')

-- replace globally
vmap('<space>s', '"hy:g~<C-r>h~s///gc<left><left><left>', { noremap = false, silent = false })

-- replace on one line
vmap('s', '"hy:.,.g~<C-r>h~s///g<left><left>', { noremap = false, silent = false })

-- INSERT

-- can undo line by line
imap('<cr>', '<c-g>u<cr>')
