local strings = require("functions.strings")
local file_ignore_patterns =
	{ ".git/", ".venv/", ".vscode/", ".databricks/", ".pytest_cache/", ".mypy_cache/", "__pycache__/" }

local function read_lines(path)
	local f = io.open(path, "r")
	if not f then
		return nil, ("Could not open: %s"):format(path)
	end
	local out = {}
	for line in f:lines() do
		if line ~= "" then
			table.insert(out, line)
		end
	end
	f:close()
	return out
end

vim.keymap.set("n", "<space>p", function()
	local file = vim.fn.getcwd() .. "/.setup/paste" -- change if you want a different base dir
	local lines, err = read_lines(file)
	if not lines then
		return vim.notify(err, vim.log.levels.WARN)
	end
	if #lines == 0 then
		return vim.notify("No entries in " .. file, vim.log.levels.INFO)
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Paste",
			finder = finders.new_table({ results = lines }),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local entry = action_state.get_selected_entry()
					local text = (entry and (entry.value or entry[1])) or nil
					if not text then
						return
					end

					local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- row: 1-based, col: 0-based (byte)
					row = row - 1
					vim.api.nvim_buf_set_text(0, row, col, row, col, { text })
					vim.api.nvim_win_set_cursor(0, { row + 1, col + #text })
				end)
				return true
			end,
		})
		:find()
end, { desc = "Paste from .setup/paste (Telescope)" })

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
				local search_term = "\\b" .. vim.fn.expand("<cword>") .. "\\b"
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
