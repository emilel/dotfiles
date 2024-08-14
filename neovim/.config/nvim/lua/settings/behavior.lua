local globals = require('globals')

-- use system clipboard
vim.opt.clipboard = "unnamedplus"

-- use undo files instead of swap files
vim.opt.swapfile = false
vim.opt.undofile = true

-- format options (see :h fo-table)
vim.opt.formatoptions = globals.formatoptions
