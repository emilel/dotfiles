vim.g.ai_indicator_text = '★'
vim.g.ai_no_mappings = 1

return {
	'aduros/ai.vim',
	keys = {
		{ '<c-s>', ':AI ',      mode = 'n', desc = 'Autocomplete with ChatGPT' },
		{ '<c-s>', '<cmd>AI<cr><esc>', mode = 'i', desc = 'Autocomplete with ChatGPT' },
		{ '<c-s>', ':AI ',             mode = 'v', desc = 'Autocomplete with ChatGPT' }
	},
}
