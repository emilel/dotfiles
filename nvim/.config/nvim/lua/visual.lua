-- COLORS

-- obviously dark mode
vim.opt.background = 'dark'

-- set theme
vim.cmd([[colorscheme gruvbox]])


-- MISC

-- current row
vim.opt.cursorline = true


-- GUTTER

-- no column for signs
vim.opt.signcolumn = 'number'

-- show line numbers in the gutter
vim.opt.number = true

-- if there are three numbers in the line number, you're doing it wrong
vim.opt.numberwidth = 2


-- STATUS LINE

-- lualine is cool
require('lualine').setup{
    icons_enabled = false
}
