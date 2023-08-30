return {
	'jpalardy/vim-slime',
	keys = {
		{ '<cr><cr>',  '<cmd>SlimeSendCurrentLine<cr>', desc = 'Send current line' },
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

		vim.g.prepend = "begin\n"
		vim.g.append = " end"
		vim.keymap.set('n', '<space>sL', function()
			vim.ui.input(
				{ prompt = 'Prepend: ' },
				function(prepend)
					vim.g.prepend = prepend
				end)vim.ui.input(
				{ prompt = 'Append: ' },
				function(append)
					vim.g.append = append
				end)
		end
		)
		vim.cmd([[
			function SlimeOverride_EscapeText_julia(text)
				return system("echo '" . g:prepend . a:text . g:append . "' | awk '{$1=$1};1'", a:text)
			endfunction
		]])
	end
}
