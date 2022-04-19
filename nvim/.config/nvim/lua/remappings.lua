-- HELPERS
local nmap = require('helpers').nmap
local imap = require('helpers').imap
local vmap = require('helpers').vmap

-- COPY

-- don't copy when deleting a character
nmap('x', '"_x')

-- but do copy on capital x
nmap('X', 'x')

-- don't copy when pasting
vmap('<space>p', '"_dP')
