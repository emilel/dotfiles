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

-- close all
nmap('<space>q', ':qa<cr>')

-- close window!
nmap('<space>C', ':q!<cr>')

-- close all!
nmap('<space>Q', ':qa!<cr>')

-- close all but currently focused
nmap('<c-q>', '<cmd>only<cr>')

-- up, down etc
nmap('<space>h', '<cmd>wincmd h<cr>')
nmap('<space>j', '<cmd>wincmd j<cr>')
nmap('<space>k', '<cmd>wincmd k<cr>')
nmap('<space>l', '<cmd>wincmd l<cr>')


-- FILE NAVIGATION
--
-- copy relative path
nmap('<space>yy', '<cmd>let @+ = fnamemodify(expand("%"), ":~:.")<cr>')

-- copy full path
nmap('<space>YY', '<cmd>let @+ = expand("%:p")<cr>')

-- go to written path
vmap('<c-f>', '"qy:edit <c-r>q', { noremap = true, silent = false })

-- open written path
vmap('<cr>', '"qy:silent !xdg-open <c-r>q &disown<cr>')

-- get path to file
vim.cmd([[inoremap <expr> <c-a> fzf#vim#complete("fd <Bar> xargs realpath --relative-to " . expand("%:h"))]])

-- MISC COMMANDS

-- can undo line by line
imap('<cr>', '<c-g>u<cr>')

-- disable search highlight
nmap('\\', '<cmd>noh<cr>')

-- toggle incsearch
nmap('<space>|', '<cmd>set is!<cr>')

-- y in visual leads to where you want to be
vmap('y', '<esc>mugvy`u')

-- mark inserted text
nmap('giv', '`[v`]')

-- go to last inserted text
nmap('gii', '`]')

-- capitalize inserted text
nmap('giU', '`[v`]gU')

-- go to marked word
nmap('gm', '`qv`w')

-- fold
-- nmap('<cr>', 'za')

-- go to end of line
vmap('L', '$h')

-- go to beginning of line
vmap('H', '^')

-- toggle fold all
vim.cmd([[nnoremap <expr> <Backspace> &foldlevel ? 'zM' :'zR']])

-- prev/next in quickfix
nmap('<space>J', '<cmd>cnext<cr>')
nmap('<space>K', '<cmd>cprev<cr>')

-- format paragraph
nmap('<space>,', 'gwap')

-- add to jump list and set mark
nmap('\'', 'm\'my')

-- go to mark
nmap('g\'', '`y')

-- select pasted text
nmap('gp', '`[v`]')

-- delete row above or below
vmap('<space>J', '<esc>`>j"_ddgv')
vmap('<space>K', '<esc>`<k"_ddgv')

-- add row above or below
vmap('<space>j', '<esc>`>o<esc>gv')
vmap('<space>k', '<esc>`<O<esc>gv')

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

-- ASSIGNMENTS ETC

-- insert in beginning of assignment
nmap('<space>I', '0f=wi')

-- replace colon thing
nmap('c:', 'f:wvf,hc')

-- select colon thing
nmap('v:', 'f:wvf,h')

-- visual select assignment
nmap('v=', '0f=wv$F,h')

-- copy assignment and delete row
nmap('d=', '0f=wD"_dd')

-- copy assignment
nmap('y=', '0f=wy$')

-- replace assignment
nmap('c=', '0f=wv$F,hc')

-- replace variable
nmap('cv', '^vf=gec')

-- visual select variable
nmap('vv', '^vf=ge')

-- mark visually selected word and copy to e
vmap('\'', '"ey`<mq`>mw')

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

-- paste inline in normal
nmap('<space>p', 'a<cr><esc>P`]')

-- paste inline in normal, trim newlines
vim.cmd([[nnoremap <space>P a<cr><esc>P`[v`]:'<,'>.!perl -pe "s/^\s*(.*?)\s*$/\1/"<cr>`[V`]jokgJdw]])

-- paste inline in visual
vim.cmd([[vnoremap <space>P "udi<cr><esc>P`[v`]:'<,'>.!perl -pe "s/^\s*(.*?)\s*$/\1/"<cr>`[V`]jokgJdw"up`[v`]d]])

-- SEARCH AND REPLACE

-- search for selection in file
vmap('/', '"hymu/\\V<C-R>=escape(@h,\'/\\\')<CR><CR>`u', { noremap = true, silent = false })

-- search for current word but don't jump
nmap('*', '*``')

-- and replace current with marked word
vmap('<space>r', '"ey`<mr`>mt`qv`w"ep`rv`tp')

-- visually select content on line
nmap('<space>V', '^v$h')

-- replace globally
vmap('<space>S', '"hy:%s/<c-r>h//gc<left><left><left>', { noremap = true, silent = false })

-- replace on one line
vmap('S', '"hy:s/<c-r>h//g<left><left>', { noremap = true, silent = false })

-- replace in visual selection
vmap('<space>s', ':s/\\V<c-r>e//g<left><left>', { noremap = true, silent = false })
