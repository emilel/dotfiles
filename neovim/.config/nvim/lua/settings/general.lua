local globals = require('globals')

-- use system clipboard
vim.opt.clipboard = "unnamedplus"

-- use undo files instead of swap files
vim.opt.swapfile = false
vim.opt.undofile = true

-- format options (see :h fo-table)
vim.opt.formatoptions = globals.formatoptions

-- don't wrap text
vim.opt.wrap = false

-- ignore case
vim.opt.ignorecase = true

-- but do care about capital letters
vim.opt.smartcase = true

-- have some lines of padding
vim.opt.scrolloff = 8

-- don't wrap to beginning of file when searching
vim.opt.wrapscan = false
