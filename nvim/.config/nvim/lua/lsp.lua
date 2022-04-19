require'lspconfig'.julials.setup{}
local nmap = require('helpers').nmap
local imap = require('helpers').imap
local vmap = require('helpers').vmap

-- format julia
nmap('<space>z', '<cmd>JuliaFormatterFormat<cr>')

-- go to definition
nmap(',d', '<cmd>lua vim.lsp.buf.definition()<cr>')

-- go to declaration
nmap(',D', '<cmd>lua vim.lsp.buf.declaration()<cr>')

-- go to implementation
nmap(',i', '<cmd>vim.lsp.buf.implementation()<cr>')

-- go to references
nmap(',r', '<cmd>lua vim.lsp.buf.references()<cr>')

-- go to previous
nmap(',N', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

-- go to next
nmap(',n', '<cmd>lua vim.diagnostic.goto_next()<cr>')

-- open float
nmap(',f', '<cmd>lua vim.diagnostic.open_float()<cr>')

-- signature help
nmap(',s', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
