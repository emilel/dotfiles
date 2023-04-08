return {
	'jpalardy/vim-slime',
	keys = {
		{ '<cr>',     '<cmd>SlimeSendCurrentLine<cr>', desc = 'Send current line' },
		{ '<space>l', '<plug>SlimeConfig',             desc = 'Configure slime' },
		{
			'<cr>',
			'<plug>SlimeRegionSend<cr>',
			mode = 'v',
			desc =
			'Send current selection to slime'
		},
		{
			'<space><cr>',
			'myggVG<plug>SlimeRegionSend<cr>`y',
			desc =
			'Send entire file to slime'
		}
	},
	config = function()
		vim.g.slime_target = "tmux"
		vim.g.slime_no_mappings = 1
		vim.g.slime_default_config = { socket_name = 'default', target_pane = ":.1" }
	end
}
