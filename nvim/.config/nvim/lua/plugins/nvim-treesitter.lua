return {
	-- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	config = function()
		pcall(require('nvim-treesitter.install').update { with_sync = true })
		require('nvim-treesitter.configs').setup({
			ensure_installed = { 'go', 'lua', 'python', 'vim' },
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true, disable = { 'python' } },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = ',,',
					node_incremental = '.',
					node_decremental = ',',
					-- scope_incremental = '+',
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						['a,'] = '@parameter.outer',
						['i,'] = '@parameter.inner',
						["ac"] = "@call.outer",
						["ic"] = "@call.inner",
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['al'] = '@class.outer',
						['il'] = '@class.inner',
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						[']m'] = '@function.outer',
						[']]'] = '@class.outer',
					},
					goto_next_end = {
						[']M'] = '@function.outer',
						[']['] = '@class.outer',
					},
					goto_previous_start = {
						['[m'] = '@function.outer',
						['[['] = '@class.outer',
					},
					goto_previous_end = {
						['[M'] = '@function.outer',
						['[]'] = '@class.outer',
					},
				},
				swap = {
					enable = true,
					swap_next = {
						[',>'] = '@parameter.outer',
					},
					swap_previous = {
						[',<'] = '@parameter.inner',
					},
				},
			},
		})
	end,
}
