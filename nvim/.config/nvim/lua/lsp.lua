local nmap = require('helpers').nmap
local imap = require('helpers').imap
local vmap = require('helpers').vmap

-- julia
require'lspconfig'.julials.setup{}

-- python
require('lspconfig')['pyright'].setup {
capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

-- lua
require('lspconfig').sumneko_lua.setup{}

-- go to definition
nmap(',gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

-- go to declaration
nmap(',gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

-- go to implementation
nmap(',gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

-- go to references
nmap(',gr', '<cmd>lua vim.lsp.buf.references()<cr>')

-- go to previous
nmap(',N', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

-- go to next
nmap(',n', '<cmd>lua vim.diagnostic.goto_next()<cr>')

-- open float
nmap(',f', '<cmd>lua vim.diagnostic.open_float()<cr>')

-- signature help
nmap(',s', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

-- rename thing
nmap(',rn', '<cmd>lua vim.lsp.buf.rename()<cr>')

-- hover
nmap(',h', '<cmd>lua vim.lsp.buf.hover()<cr>')

-- code action
nmap(',a', '<cmd>lua vim.lsp.buf.code_action()<cr>')

-- set project diagnostics in quick fix list
nmap(',dq', '<cmd>lua vim.diagnostic.setqflist()<cr>')
