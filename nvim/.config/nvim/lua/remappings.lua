-- HELPERS
local nmap = require('helpers').nmap
local imap = require('helpers').imap
local vmap = require('helpers').vmap

-- COPY

-- don't copy when deleting a character
nmap('x', '"_x')

-- but do copy on capital x
nmap('X', 'x')

-- and space x
nmap('<space>x', 'x')

-- don't copy when pasting
vmap('<space>p', '"_dP')

-- search with perl
-- nmap('\\', '/\\v', { noremap = false, silent = false })

-- space does nothing
nmap('<space>', '<nop>')

-- nmap('*', '<cmd>keepjumps normal! mi*`i<CR>')
nmap('*', '*``')

-- go to previous word
nmap('z', 'ge')
nmap('Z', 'gE')
vmap('z', 'ge')
vmap('Z', 'gE')

-- dont jump when starring
-- vim.cmd([[nmap <silent> * "syiw<Esc>: let @/ = @s<CR>:set hls<cr>]])
