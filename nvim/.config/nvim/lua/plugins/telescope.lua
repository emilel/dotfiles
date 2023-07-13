return {
	'nvim-telescope/telescope.nvim',
	keys = {
		{
			'<space>*',
			'"yy:lua require("telescope.builtin").grep_string({ search = "<c-r>y" })<cr>',
			mode = 'v',
			desc = 'Search for highlighted string in workspace'
		},
		{
			'<space>*',
			'<cmd>lua require("telescope.builtin").grep_string({ search = "", only_sort_text = true })<cr>',
			mode = 'n',
			desc = 'Fuzzy search in workspace'
		},
		{
			'<space>\\',
			'<cmd>Telescope live_grep<cr>',
			desc = 'Search in workspace'
		},
		{
			'<space>/',
			require("config.functions").telescope_resume,
			desc = 'Continue search'
		},
		{
			'<space>m',
			'<cmd>lua require("telescope.builtin").keymaps()<cr>',
			desc = 'Keymaps'
		},
		-- {
		-- 	'<space>\\',
		-- 	'<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>',
		-- 	desc = 'Fuzzily search current buffer'
		-- },
		{
			'<space>A',
			'<cmd>lua require("telescope.builtin").buffers()<cr>',
			desc = 'Currently open buffers'
		},
		-- {
		-- 	'<space>a',
		-- 	'<cmd>Telescope find_files<cr>',
		-- 	desc = 'Search files'
		-- },
		{
			'<space>sh',
			'<cmd>lua require("telescope.builtin").help_tags()<cr>',
			desc = 'Search help'
		},
		{
			'<space>sw',
			'<cmd>lua require("telescope.builtin").grep_string()<cr>',
			desc = 'Search current word'
		},
		{
			'<space>sg',
			'<cmd>lua require("telescope.builtin").live_grep()<cr>',
			desc = 'Search grep'
		},
		{
			'<space>sd',
			'<cmd>lua require("telescope.builtin").diagnostics()<cr>',
			desc = 'Search diagnostics'
		}
	},
	config = function()
		require('telescope').setup({
			pickers = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					additional_args = function(_)
						return { '--hidden' }
					end
				},
				grep_string = {
					additional_args = function(_)
						return { '--hidden' }
					end,
					lsp_dynamic_workspace_symbols = {
						sorter = require("telescope").extensions.fzf.native_fzf_sorter({
							fuzzy = true, -- false will only do exact matching
							override_generic_sorter = true, -- override the generic sorter
							override_file_sorter = true, -- override the file sorter
							case_mode = "smart_case",
						})
					},
				},
			},
			defaults = {
				preview = true,
				file_ignore_patterns = {
					'\\.git',
					'old/*',
					'%.png',
					'%.pdf',
					'%.pt',
					'%.pickle',
					'%.png',
					'%.pkl',
				},
				layout_strategy = 'vertical',
				layout_config = {
					preview_cutoff = 0
				},
				mappings = {
					i = {
						['<C-q>'] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
						['<tab>'] = require('telescope.actions').toggle_selection,
						['<c-space>'] = require('telescope.actions').toggle_selection,
						['<C-j>'] = require('telescope.actions').move_selection_next,
						['<C-k>'] = require('telescope.actions').move_selection_previous,
						['<esc>'] = require('telescope.actions').close
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = false,
					case_mode = "smart_case",
				},
			}
		})
		pcall(require('telescope').load_extension, 'fzf')
	end,
	version = '*',
	dependencies = {
		'nvim-lua/plenary.nvim',
	}
}
