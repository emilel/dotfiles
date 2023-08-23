return {
	'jpalardy/vim-slime',
	keys = {
		{ '<cr><cr>',     '<cmd>SlimeSendCurrentLine<cr>', desc = 'Send current line' },
		{ '<space>sl', '<plug>SlimeConfig',             desc = 'Configure slime' },
		{
			'<cr>',
			'<esc>mygv<plug>SlimeRegionSend<cr>`y',
			mode = 'v',
			desc =
			'Send current selection to slime'
		},
	},
	config = function()
		vim.g.slime_target = "tmux"
		vim.g.slime_no_mappings = 1
		vim.g.slime_default_config = { socket_name = 'default', target_pane = ":run.bottom-right" }
	end
}
