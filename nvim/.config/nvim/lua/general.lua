-- GENERAL

-- can switch buffer without saving
vim.opt.hidden = true

-- don't wrap long lines
vim.opt.wrap = false

-- don't keep swap files
vim.opt.swapfile = false

-- allow mouse usage
vim.opt.mouse = 'a'

-- use global clipboard
vim.opt.clipboard = 'unnamedplus'

-- persistent undo
vim.opt.undofile = true

-- SEARCH

-- only highlight the current match
vim.opt.hlsearch = false

-- don't care about case until capital letter
vim.opt.smartcase = true

-- search immediately
vim.opt.incsearch = true

-- INDENTATION

-- use spaces when pressing tab
vim.opt.expandtab = true

-- width of existing hard tabs
vim.opt.tabstop = 4

-- how many spaces per shift
vim.opt.shiftwidth = 4

-- spaces per tab
vim.opt.softtabstop = 4

-- show whitespace in normal but not insert mode
vim.opt.list = true
vim.opt.listchars = { tab = '>-', trail = '-' }

local whitespace_group = vim.api.nvim_create_augroup(
    'visible_whitespace',
    { clear = true }
)
vim.api.nvim_create_autocmd(
    'InsertEnter',
    { command = 'setl nolist', group = whitespace_group }
)
vim.api.nvim_create_autocmd(
    'InsertLeave',
    { command = 'setl list', group = whitespace_group }
)


-- FORMATTING OPTIONS (h fo-table)

vim.opt.formatoptions = 'tcrq2jl'


-- FORMATTING

vim.opt.textwidth = 79
vim.opt.colorcolumn = '80'
