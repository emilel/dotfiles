return {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v2.x',
	dependencies = {
		-- LSP Support
		{ 'neovim/nvim-lspconfig' },
		{ 'nvim-telescope/telescope.nvim' },
		{
			-- Optional
			'williamboman/mason.nvim',
			build = function()
				pcall(vim.cmd, 'MasonUpdate')
			end,
		},
		{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

		-- Autocompletion
		{ 'hrsh7th/nvim-cmp' },
		{ 'hrsh7th/cmp-nvim-lsp' },
		{ 'hrsh7th/cmp-buffer' },
		{ 'hrsh7th/cmp-nvim-lua' },
		{ 'L3MON4D3/LuaSnip' },
		{ 'saadparwaiz1/cmp_luasnip' }
	},
	config = function()
		local lsp = require('lsp-zero').preset({})

		lsp.on_attach(function(_, bufnr)
			lsp.default_keymaps({ buffer = bufnr })

			local nmap = function(keys, func, desc)
				if desc then
					desc = 'LSP: ' .. desc
				end

				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
			end

			nmap(',rn', vim.lsp.buf.rename, 'Rename')
			nmap(',ca', vim.lsp.buf.code_action, 'Code action')

			nmap(',gd', vim.lsp.buf.definition, 'Go to definition')
			nmap(',gr', require('telescope.builtin').lsp_references, 'Go to references')
			nmap(',gI', vim.lsp.buf.implementation, 'Goto implementation')
			nmap(',D', vim.lsp.buf.type_definition, 'Type definition')
			nmap(',f', vim.diagnostic.open_float, 'Open diagnostic in floating window')
			nmap(',dq', vim.diagnostic.setqflist, 'Open diagnostics in quickfix list')
			nmap(',ds', require('telescope.builtin').lsp_document_symbols, 'Document symbols')
			nmap(',ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace symbols')

			-- See `:help K` for why this keymap
			nmap('K', vim.lsp.buf.hover, 'Hover documentation')
			nmap(',k', vim.lsp.buf.signature_help, 'Signature documentation')

			-- Lesser used LSP functionality
			nmap(',gD', vim.lsp.buf.declaration, 'Go to declaration')
			nmap(',wa', vim.lsp.buf.add_workspace_folder, 'Workspace add folder')
			nmap(',wr', vim.lsp.buf.remove_workspace_folder, 'Workspace remove folder')
			nmap(',l', '<cmd>LspStop<cr>', 'Stop LSP')
			nmap(',L', '<cmd>LspStop<cr>', 'Start LSP')
			nmap(',wl', function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, 'Workspace list folders')

			-- Format
			vim.keymap.set('n', ',z', vim.lsp.buf.format, { desc = 'Format current buffer with LSP' })
			vim.api.nvim_buf_create_user_command(bufnr, 'Format', vim.lsp.buf.format,
				{ desc = 'Format current buffer with LSP' })
		end)

		require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
		local cmp = require('cmp')
		local luasnip = require 'luasnip'
		cmp.setup({
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = 'nvim_lua' },
				{ name = 'luasnip' },
				{ name = 'nvim_lsp' },
				{ name = 'buffer',  keyword_length = 5 }
			}),
			mapping = cmp.mapping.preset.insert {
				['<C-Space>'] = cmp.mapping.complete {},
				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
				['<c-l>'] = cmp.mapping(function(fallback)
					if luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif cmp.visible() then
						cmp.mapping.confirm {
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						} ()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<c-h>'] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					elseif cmp.visible() then
						cmp.mapping.close {} ()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<c-j>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<c-k>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { 'i', 's' }),
			}
		})

		lsp.setup()
	end
}
