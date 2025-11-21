local strings = require("functions.strings")
local file_ignore_patterns =
	{ ".git/", ".venv/", ".vscode/", ".databricks/", ".pytest_cache/", ".mypy_cache/", "__pycache__/" }

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
		"danielfalk/smart-open.nvim",
		"kkharji/sqlite.lua",
		"nvim-telescope/telescope-fzy-native.nvim",
	},
	keys = {
		{
			"<space>a",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<space>f",
			function()
				require("telescope").extensions.smart_open.smart_open()
			end,
			desc = "Find files",
		},
		{
			"<space>/",
			function()
				require("telescope").extensions.live_grep_args.live_grep_args()
			end,
			desc = "Grep all files",
		},
		{
			"<space>*",
			function()
				vim.cmd('normal! "yy')
				local search_term = vim.fn.getreg("y")
				local esaped_search_term = strings.escape_pcre(search_term)
				require("telescope").extensions.live_grep_args.live_grep_args({ default_text = esaped_search_term })
			end,
			desc = "Search for selected string in current working directory",
			mode = "x",
		},
		{
			"<space>*",
			function()
				local search_term = "\\<" .. vim.fn.expand("<cword>") .. "\\>"
				require("telescope").extensions.live_grep_args.live_grep_args({ default_text = search_term })
			end,
			desc = "Search for current word in current working directory",
		},
		{
			"<space>t",
			function()
				require("telescope.builtin").resume()
			end,
			desc = "Resume telescope",
		},
		{
			"<space>m",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "Show mappings",
		},
		{
			"<space>s",
			function()
				require("telescope.builtin").lsp_document_symbols({ symbol_width = 50 })
			end,
			desc = "LSP document symbols",
		},
		{
			"<space>S",
			require("telescope.builtin").lsp_workspace_symbols,
			desc = "Search for workspace symbols",
		},
		{
			"<space>f",
			function()
				vim.cmd('normal! "yy')
				local selected_text = vim.fn.getreg("y")
				require("telescope").extensions.smart_open.smart_open({ default_text = selected_text })
			end,
			desc = "Find file",
			mode = "x",
		},
		{
			"<space>n/",
			function()
				local file_name = strings.get_file_name()
				require("telescope").extensions.live_grep_args.live_grep_args({ default_text = file_name })
			end,
			desc = "Find references to file",
		},
	},
	config = function()
		local telescope = require("telescope")
		local lga_actions = require("telescope-live-grep-args.actions")

		telescope.setup({
			defaults = {
				file_ignore_patterns = file_ignore_patterns,
				path_display = function(_, path)
					local tail = require("telescope.utils").path_tail(path)
					local directory = path:match("(.*/)") or "./"
					local formatted_path = string.format("%s %s", tail, directory)
					local path_start = #tail + 1
					local highlights = {
						{
							{
								path_start,
								#formatted_path,
							},
							"Function",
						},
					}

					return formatted_path, highlights
				end,
				layout_strategy = "vertical",
				layout_config = {
					vertical = {
						preview_cutoff = 30,
					},
				},
				mappings = {
					i = {
						["<esc>"] = require("telescope.actions").close,
						["<c-j>"] = require("telescope.actions").move_selection_next,
						["<c-k>"] = require("telescope.actions").move_selection_previous,
						["<c-q>"] = require("telescope.actions").smart_send_to_qflist,
						["<c-space>"] = require("telescope.actions").toggle_selection,
						["<c-x>"] = require("telescope.actions").delete_buffer,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
				grep_string = {
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
				buffers = {
					ignore_current_buffer = false,
					file_ignore_patterns = { "^fugitive://" },
					sort_mru = true,
				},
			},
			extensions = {
				live_grep_args = {
					additional_args = function(_)
						return { "--hidden", "--smart-case" }
					end,
					mappings = {
						i = {
							["<C-'>"] = lga_actions.quote_prompt(),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t " }),
						},
					},
				},
				smart_open = {
					hidden = true,
					ignore_patterns = file_ignore_patterns,
					cwd_only = true,
				},
			},
		})

		telescope.load_extension("live_grep_args")
		telescope.load_extension("smart_open")
	end,
	lazy = true,
}
