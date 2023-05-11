-- don't indent crazily
vim.opt.tabstop = 4

-- cursor line
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, 'cursorlinenr', { fg = 'darkyellow', bold = true })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
local cursorline = vim.api.nvim_create_augroup(
	'cursorline',
	{ clear = true }
)
vim.api.nvim_create_autocmd(
	{ 'FocusGained' },
	{
		group = cursorline,
		callback = function()
			vim.opt.cursorline = true
		end
	}
)
vim.api.nvim_create_autocmd(
	{ 'FocusLost' },
	{
		group = cursorline,
		callback = function()
			vim.opt.cursorline = false
		end
	}
)

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
  group = highlight_group,
  pattern = '*',
})
