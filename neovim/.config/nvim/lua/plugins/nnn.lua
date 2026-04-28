return {
	"luukvbaal/nnn.nvim",
	opts = {},
	keys = {
		{
			"_",
			"<cmd>NnnPicker<cr>",
			desc = "Pick file",
		},
		{
			"-",
			"<cmd>NnnPicker %:p:h<cr>",
			desc = "Open file's directory",
		},
		{
			"<space>g",
			function()
				-- Remember the window you're in BEFORE Telescope opens
				local source_win = vim.api.nvim_get_current_win()

				-- Lazy-load telescope if needed
				local ok_lazy, lazy = pcall(require, "lazy")
				if ok_lazy then
					lazy.load({ plugins = { "telescope.nvim" } })
				end

				local cwd = vim.fn.getcwd()

				local ignore = {
					".git",
					".venv",
					".vscode",
					".databricks",
					".pytest_cache",
					".mypy_cache",
					"__pycache__",
				}

				local cmd
				if vim.fn.executable("fd") == 1 then
					cmd = { "fd", "--type", "d", "--hidden", "--follow" }
					for _, x in ipairs(ignore) do
						table.insert(cmd, "--exclude")
						table.insert(cmd, x)
					end
					table.insert(cmd, ".")
				else
					cmd = { "find", ".", "-type", "d" }
					for _, x in ipairs(ignore) do
						table.insert(cmd, "-not")
						table.insert(cmd, "-path")
						table.insert(cmd, "./" .. x .. "/*")
					end
				end

				local pickers = require("telescope.pickers")
				local finders = require("telescope.finders")
				local conf = require("telescope.config").values
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")

				pickers
					.new({}, {
						prompt_title = "Directories",
						finder = finders.new_oneshot_job(cmd, { cwd = cwd }),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(prompt_bufnr, _)
							actions.select_default:replace(function()
								local entry = action_state.get_selected_entry()
								actions.close(prompt_bufnr)

								local dir = entry and (entry.path or entry.value or entry[1]) or nil
								if not dir or dir == "." then
									dir = cwd
								elseif not dir:match("^/") then
									dir = cwd .. "/" .. dir
								end

								-- IMPORTANT: run NnnPicker from the original window, after Telescope is gone
								vim.schedule(function()
									if vim.api.nvim_win_is_valid(source_win) then
										vim.api.nvim_set_current_win(source_win)
									end

									vim.cmd("NnnPicker " .. vim.fn.fnameescape(dir))

									-- Make sure terminal is in insert mode
									vim.schedule(function()
										pcall(vim.cmd, "startinsert")
									end)
								end)
							end)
							return true
						end,
					})
					:find()
			end,
			desc = "Pick directory (Telescope) and open nnn",
		},
	},
}
