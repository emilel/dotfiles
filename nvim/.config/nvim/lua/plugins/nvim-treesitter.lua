return {
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	config = function()
		pcall(require('nvim-treesitter.install').update { with_sync = true })
		require('nvim-treesitter.configs').setup({
			-- rainbow = {
			-- 	enable = true,
			-- 	query = 'rainbow-parens',
			-- 	-- strategy = require('ts-rainbow').strategy.global,
			-- 	hlgroups = {
			-- 		'TSRainbowYellow',
			-- 		'TSRainbowBlue',
			-- 		'TSRainbowGreen',
			-- 		'TSRainbowOrange',
			-- 		'TSRainbowCyan',
			-- 		'TSRainbowViolet',
			-- 		'TSRainbowRed',
			-- 	},
			-- },
			ensure_installed = { 'go', 'lua', 'python', 'vim' },
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true, disable = { 'python' } },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<backspace>',
					node_incremental = '<backspace>',
					node_decremental = '<space><backspace>',
					-- scope_incremental = '+',
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						-- ['a,'] = '@parameter.outer',
						-- ['i,'] = '@parameter.inner',
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
						[']f'] = '@function.outer',
						[']c'] = '@class.outer',
					},
					goto_next_end = {
						[']F'] = '@function.outer',
						[']C'] = '@class.outer',
					},
					goto_previous_start = {
						['[f'] = '@function.outer',
						['[c'] = '@class.outer',
					},
					goto_previous_end = {
						['[F'] = '@function.outer',
						['[C'] = '@class.outer',
					},
				},
				-- swap = {
				-- 	enable = true,
				-- 	swap_next = {
				-- 		[',>'] = '@parameter.outer',
				-- 	},
				-- 	swap_previous = {
				-- 		[',<'] = '@parameter.inner',
				-- 	},
				-- },
			},
		})
	end,
}
