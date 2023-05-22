return {
	'ggandor/lightspeed.nvim',
	config = function()
		require('lightspeed').opts.ignore_case = true
		vim.api.nvim_set_hl(0, 'LightSpeedCursor', { bg = 'orange' })
	end,
	keys = { { 's', 's', 'Vim builtin' } },
}
