-- HELPERS
local nmap = require('helpers').nmap
local imap = require('helpers').imap
local vmap = require('helpers').vmap

-- MISC

-- reload vimrc
nmap('<space>R', '<cmd>source $MYVIMRC<cr>', { noremap = true, silent = false })

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


-- replace assignment
nmap('cC', '0f=wC')

-- y in visual leads to where you want to be
vmap('y', '<esc>mugvy`u')

-- mark visually selected word and copy to e
vmap('\'', '"ey`<mq`>mw')

-- and replace current with marked word
vmap('R', '"ey`<mr`>mt`qv`w"ep`rv`tp')

-- go to marked word
nmap('gm', '`qv`w')

-- visually select content on line
vmap('<space>V', '^v$h')

-- fold
nmap('<cr>', 'za')

-- go to end of line
vmap('L', '$h')

-- go to beginning of line
vmap('H', '^')

-- toggle fold all
vim.cmd([[nnoremap <expr> <Backspace> &foldlevel ? 'zM' :'zR']])

-- prev/next in quickfix
nmap('<c-j>', '<cmd>cnext<cr>')
nmap('<c-k>', '<cmd>cprev<cr>')

-- format paragraph
nmap('<space>,', 'gwap')

-- add to jump list
nmap('\'', 'm\'')

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

nmap('<space>d', '"_d')
nmap('<space>d', '"_d')
nmap('<space>D', '"_D')

-- copy to end of line
nmap('Y', 'y$')

-- delete to end of line and delete line
nmap('<space>D', 'D"_dd')

-- SEARCH AND REPLACE

-- search for selection in file
vmap('/', '"hy/\\V<C-R>=escape(@h,\'/\\\')<CR><CR>', { noremap = true, silent = false })

-- replace globally
-- vmap('<space>S', '"hy:g~<C-r>h~s///gc<left><left><left>', { noremap = true, silent = false })
vmap('<space>S', '"hy:%s/<c-r>h//gc<left><left><left>', { noremap = true, silent = false })

-- replace on one line
-- vmap('s', '"hy:.,.g~<C-r>h~s///g<left><left>', { noremap = true, silent = false })
vmap('s', '"hy:s/<c-r>h//g<left><left>', { noremap = true, silent = false })

-- replace in visual selection
vmap('<space>s', ':s/<c-r>e//g<left><left>', { noremap = true, silent = false })

-- mark inserted text
nmap('giv', '`[v`]')

-- INSERT

-- can undo line by line
imap('<cr>', '<c-g>u<cr>')
