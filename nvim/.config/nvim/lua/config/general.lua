-- Set highlight on search
vim.o.hlsearch = true

-- set title
vim.opt.title = true
vim.opt.titlestring ='%F'

-- don't conceal
vim.opt.conceallevel = 0

-- line break comments
vim.opt.formatoptions:append('t')
vim.opt.formatoptions:append('c')
vim.opt.formatoptions:append('r')
vim.opt.formatoptions:append('q')
vim.opt.formatoptions:append('2')
vim.opt.formatoptions:append('j')
vim.opt.formatoptions:append('l')
-- tcrq2jl

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- don't keep swap files
vim.opt.swapfile = false

-- don't wrap lines
vim.opt.wrap = false

-- keep a few lines visible up and down
vim.opt.scrolloff = 8

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- relative numbers in number column
vim.opt.relativenumber = true

-- show whitespace
local whitespace_group = vim.api.nvim_create_augroup(
	'visible_whitespace',
	{ clear = true }
)
vim.api.nvim_create_autocmd(
	'InsertEnter',
	{
		group = whitespace_group,
		callback = function()
			vim.opt_local.list = false
		end
	}
)
vim.api.nvim_create_autocmd(
	'InsertLeave',
	{
		group = whitespace_group,
		callback = function()
			vim.opt_local.list = true
		end
	}
)
