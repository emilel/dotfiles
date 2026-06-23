-- All global editor options live here (formerly settings/general.lua,
-- settings/visual.lua and a stray vim.opt in keymaps.lua).
local globals = require("globals")

-- behaviour -----------------------------------------------------------------
vim.opt.clipboard = "unnamedplus" -- use the system clipboard
vim.opt.swapfile = false -- prefer undo files over swap files
vim.opt.undofile = true
vim.opt.formatoptions = globals.formatoptions -- see :h fo-table
vim.opt.wrap = false -- don't wrap long lines
vim.opt.ignorecase = true -- case-insensitive search...
vim.opt.smartcase = true -- ...unless the query has capitals
vim.opt.scrolloff = 8 -- keep some padding around the cursor
vim.opt.wrapscan = false -- don't wrap to BOF when searching
vim.opt.textwidth = 80

-- appearance ----------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes:1"
vim.opt.cursorline = true
vim.opt.conceallevel = 0
vim.opt.expandtab = true -- spaces instead of tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- folding -------------------------------------------------------------------
-- Treesitter-based folds: the first line of each node (function signature,
-- class name, markdown heading, ...) stays visible while the body collapses.
-- An empty foldtext makes Neovim render that first line with its real syntax
-- highlighting instead of the default washed-out gray summary.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevelstart = 99
vim.opt.foldlevel = 99
vim.opt.fillchars:append({ fold = " " }) -- no trailing dots after the fold line
