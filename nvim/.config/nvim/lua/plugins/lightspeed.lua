return {
	'ggandor/lightspeed.nvim',
	config = function()
		require('lightspeed').opts.ignore_case = true
	end,
	keys = { { 's', 's', 'Vim builtin' } }
}
