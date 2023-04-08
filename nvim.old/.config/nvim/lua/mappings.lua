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

-- find placeholder
nmap('<space><space>', '/<-><cr>va>c')

-- save and exit
-- nmap('<cr><cr>', '<cmd>wq<cr>')

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
-- vmap('<cr>', '"qy:silent !xdg-open <c-r>q &disown<cr>')

-- get path to file
vim.cmd([[inoremap <expr> <c-a> fzf#vim#complete("fd <Bar> xargs realpath --relative-to " . getcwd())]])

vmap('<c-^>', '<esc><c-^>')

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

-- format leads to where you want to be, except that it doesn't work. sigh
vmap('gc', '<esc>mugvgc`u', { noremap = false })

-- fold
-- nmap('<cr>', 'za')

-- disable colorcolumn
nmap(',c', '<cmd>set colorcolumn=0<cr>')

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

nmap('<space>z', '<cmd>%s/\\s\\+$//e<cr>')

-- add to jump list and set mark
nmap('\'', 'm\'my')

-- go to mark
nmap('g\'', '`y')

-- select pasted text
nmap('gp', '`[v`]')

-- delete row above or below
vmap('<space>J', '<esc>`>j"_ddgv')
vmap('<space>K', '<esc>`<k"_ddgv')

-- copy selection and delete line
vmap('D', 'y"_dd')

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
nmap('c:', '0f:wvf,hc')

-- select colon thing until comma
nmap('v:', '0f:wvf,h')

-- visual select assignment
nmap('v==', '0f=wv$h')

-- visual select assignment until comma
nmap('v=,', '0f=wvt,', { noremap = false, silent = true })

-- copy assignment and delete row
nmap('d=', '0f=wD"_dd')

-- copy assignment
nmap('y==', '0f=wy$')

-- copy assignment until comma
nmap('y=,', '0f=wy$')

-- replace assignment
nmap('c==', '0f=wv$F,hc')

-- replace assignment until comma
nmap('c=,', '0f=wvf,hc')

-- replace variable
nmap('cv', '^vf=gec')

-- visual select variable
nmap('v=v', '^vf=ge')

-- visual select variable and equals
nmap('v=a', '^vf=wh')

-- visual assignment right side
nmap('v=e', '^f=wv$h')

-- mark visually selected word and copy to e
vmap('\'', '"ey`<mq`>mw')

-- COPY

-- append to copy register
vmap('Y', '<esc>mi`<ms`>me`sv`e"oy`sO<esc>p`[mt`]a<cr><esc>"opmnv`td"_dd`i')

-- paste from appended register
nmap('<space>b', '<cmd>let @+ = @U<cr>"up`[mz`]xv`zd')

-- don't copy when prepending space
vmap('<space>d', '"_d')
vmap('<space>d', '"_d')

nmap('<space>d', '"_d')
nmap('<space>d', '"_d')
nmap('<space>D', '"_D')

vmap('<space>c', '"_c')

-- copy to end of line
nmap('Y', 'y$')

-- delete to end of line and delete line
nmap('<space>D', 'D"_dd')

-- paste inline in normal
nmap('<space>p', 'a<cr><esc>P`]')

-- paste inline in normal, trim newlines
-- vim.cmd([[nnoremap <space>P a<cr><esc>P`[v`]:'<,'>.!perl -pe "s/^\s*(.*?)\s*$/\1/"<cr>`[V`]jokgJdw]])

-- paste inline in visual
-- vim.cmd([[vnoremap <space>P "udi<cr><esc>P`[v`]:'<,'>.!perl -pe "s/^\s*(.*?)\s*$/\1/"<cr>`[V`]jokgJdw"up`[v`]d]])

-- SEARCH AND REPLACE

-- search for selection in file
vmap('/', '"hymu:set noincsearch<cr>/\\V<C-R>=escape(@h,\'/\\\')<CR><CR>:set incsearch<cr>`u')
-- vmap('/', '"hy:set hlsearch<cr>:let @/=\"<C-R>=escape(@h,\'/\\\')<cr>\"<cr>')

-- search for current word but don't jump
nmap('*', '*``')

-- and replace current with marked word
vmap('m', '"ey`<mr`>mt`qv`w"ep`rv`tp')

-- visually select content on line
nmap('<space>v', '^v$h')

-- replace globally
vmap('<space>R', '"hy:%s/<C-R>=escape(@h,\'/\\\')<CR>//gc<left><left><left>', { noremap = true, silent = false })

-- replace on one line
vmap('r', '"hy:s/<C-R>=escape(@h,\'/\\\')<CR>//g | :noh<left><left><left><left><left><left><left><left><left>', { noremap = true, silent = false })

-- replace in visual selection
vmap('<space>r', ':s/\\%V<c-r>e//g<left><left>', { noremap = true, silent = false })
