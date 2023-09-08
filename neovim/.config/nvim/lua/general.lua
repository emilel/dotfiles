local globals = require('globals')

-- # general

-- ## show number column

vim.opt.number = true

-- ## show sign column

vim.opt.signcolumn = 'yes'

-- ## set textwidth

vim.opt.textwidth = 80

-- ## use system clipboard

vim.opt.clipboard = "unnamedplus"

-- # indentation

-- ## use spaces instead of tabs

vim.opt.expandtab = true

-- ## indentation level

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- ## don't hide things

vim.opt.conceallevel = 0

-- ## use undo files instead of swap files

vim.opt.swapfile = false
vim.opt.undofile = true

-- # format options

-- c: autowrap comments inserting the current comment leader
-- r: insert current comment leader after <cr> in insert mode
-- q: allow comment formatting
-- a: automatic formatting of paragraphs (only for recognized comments)
-- n: recognize lists and use the indentation of the first line for the rest
-- j: remove comment leader when joining lines

vim.opt.formatoptions = globals.formatoptions

-- # search

-- ## ignore case

vim.opt.smartcase = true

-- # terminal mode

-- ## start in insert mode

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    desc = 'Set terminal to insert mode',
    group = vim.api.nvim_create_augroup("enter_terminal", { clear = true }),
    pattern = 'term://*',
    callback = function()
        vim.schedule(function()
            vim.cmd(':startinsert')
        end)
    end,
})
