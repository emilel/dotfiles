local yank = require("functions.yank")
local strings = require("functions.strings")

-- save file
vim.keymap.set("n", "<c-space>", "<cmd>write<cr>", { desc = "Save file" })

-- close buffer
vim.keymap.set("n", "<space>w", "<cmd>bd<cr>", { desc = "Close buffer" })
vim.keymap.set("n", "<space>W", "<cmd>bd!<cr>", { desc = "Force close buffer" })

-- focus window
vim.keymap.set("n", "<space>h", "<cmd>wincmd h<cr>", { desc = "Focus window to the left" })
vim.keymap.set("n", "<space>j", "<cmd>wincmd j<cr>", { desc = "Focus window below" })
vim.keymap.set("n", "<space>k", "<cmd>wincmd k<cr>", { desc = "Focus window above" })
vim.keymap.set("n", "<space>l", "<cmd>wincmd l<cr>", { desc = "Focus window to the right" })

-- close Neovim
vim.keymap.set("n", "<space>q", "<cmd>q<cr>", { desc = "Close Neovim" })
vim.keymap.set("n", "<space>Q", "<cmd>q!<cr>", { desc = "Force close Neovim" })

-- limit text width
vim.opt.textwidth = 80

-- move cursor
vim.keymap.set("i", "<c-j>", "<down>", { desc = "Move cursor down" })
vim.keymap.set("i", "<c-k>", "<up>", { desc = "Move cursor up" })

-- keep visual selection when indenting
vim.keymap.set("v", "<", "<gv", { desc = "Keep visual selection when indenting" })
vim.keymap.set("v", ">", ">gv", { desc = "Keep visual selection when indenting" })

-- select line
vim.keymap.set("n", "<space>v", "^v$h", { desc = "Select line" })

-- select entire file
vim.keymap.set("n", "<space>V", "gg0VG", { desc = "Select entire file" })

-- select pasted text
vim.keymap.set("n", "gp", "`[v`]", { desc = "Select pasted text" })

-- open quickfix list
vim.keymap.set("n", "<space><c-q>", "<cmd>copen<cr><cmd>wincmd k<cr>", { desc = "Open quickfix list" })

-- navigate quickfix list
vim.keymap.set("n", "<c-j>", "<cmd>cnext<cr>", { desc = "Next item in quickfix" })
vim.keymap.set("n", "<c-k>", "<cmd>cprev<cr>", { desc = "Previous item in quickfix" })

-- don't jump on star
vim.keymap.set("n", "*", function()
	local search_term = vim.fn.expand("<cword>")
	vim.o.hlsearch = true
	vim.fn.setreg("/", "\\<" .. search_term .. "\\>")
end, { desc = "Don't jump when pressing star" })

vim.keymap.set("x", "*", function()
	vim.cmd('normal! "yy')
	local search_term = vim.fn.getreg("y")
	search_term = strings.escape_vim(search_term)

	-- Collect lines
	local lines = {}
	for line in (search_term .. "\n"):gmatch("(.-)\n") do
		-- Trim only leading whitespace on each line
		line = line:gsub("^%s*", "")
		table.insert(lines, line)
	end

	-- If we never had a trailing newline in the original text, we might end up
	-- with an extra empty line at the end — remove it
	if not search_term:match("\n$") and lines[#lines] == "" then
		table.remove(lines)
	end

	-- If there's only one line, no newline was truly intended, so just use that
	if #lines == 1 then
		search_term = lines[1]
	else
		-- Otherwise, we have multiple lines, so join them with \n\s* in between
		-- and allow optional leading whitespace on the first line
		search_term = "\\s*" .. table.concat(lines, "\\n\\s*")
	end

	vim.o.hlsearch = true
	vim.fn.setreg("/", search_term)
end, { desc = "Don't jump when pressing star" })

vim.keymap.set("n", "?", function()
	local input = vim.fn.input("?")
	vim.fn.setreg("/", input)
	vim.cmd("set hlsearch")
end, { desc = "Set search without jumping" })

-- edit search register
vim.keymap.set("n", "<space>?", function()
	local search_term = vim.fn.getreg("/")
	vim.api.nvim_feedkeys("/" .. search_term, "n", false)
end, { desc = "Edit search" })

-- append to search
vim.keymap.set("x", "<space>/", function()
	vim.api.nvim_feedkeys('"yy', "x", false)
	local previous_search = vim.fn.getreg("/")
	local search_term = vim.fn.getreg("y")
	search_term = strings.escape_vim(search_term)
	local new_search = previous_search .. "\\|" .. search_term
	vim.fn.setreg("/", new_search)
end, { desc = "Append to search" })

-- append word to search
vim.keymap.set("n", "<space><space>*", function()
	local search_term = vim.fn.expand("<cword>")
	local previous_search = vim.fn.getreg("/")
	search_term = strings.escape_vim(search_term)
	local new_search = previous_search .. "\\|\\<" .. search_term .. "\\>"
	vim.fn.setreg("/", new_search)
end)

-- horizontal scroll
vim.keymap.set("n", "H", "zH", { desc = "Scroll to the left" })
vim.keymap.set("n", "L", "zL", { desc = "Scroll to the right" })

-- make full screen
vim.keymap.set("n", "<c-f>", "<cmd>only<cr>", { desc = "Make full screen" })

-- toggle fold
vim.keymap.set("n", "<backspace>", "za", { desc = "Toggle fold" })

-- set filetype
vim.keymap.set("n", "<space>T", ":set filetype=", { desc = "Set filetype" })

-- keep cursor still after visual mode
vim.keymap.set("x", "y", "ygv<esc>", { desc = "Keep cursor when copying visual selection" })

-- L to go to end of line
vim.keymap.set("x", "L", "$h", { desc = "Go to end of line" })

-- open temporary buffer
vim.keymap.set("n", "<space>b", function()
	yank.open_buffer()
	yank.set_exit_keymap("bdelete!")
end, { desc = "Open temporary buffer" })

-- print current path
vim.api.nvim_set_keymap("n", "<C-t>", "<C-g>", { noremap = true, silent = true })

-- print time of last modification
vim.keymap.set("n", "<space><C-t>", function()
	local file = vim.fn.expand("%")
	print(
		"Last modified: "
			.. os.date("%Y-%m-%d %H:%M:%S", vim.fn.getftime(file))
			.. ", File size: "
			.. vim.fn.getfsize(file)
			.. " bytes"
	)
end, { noremap = true, silent = true })

-- run q macro
vim.keymap.set("n", "Q", "@q", { desc = "Run q macro" })

-- insert three backticks
vim.keymap.set("n", "<space>``", "a```<cr>```<esc>k$", { desc = "Insert codeblock" })

-- disable mouse
vim.keymap.set("n", "<space>M", "<cmd>set mouse=<cr>", { desc = "Disable mouse" })

-- cycle buffers
vim.keymap.set("n", "<tab>", "<cmd>bnext<cr>", { desc = "Cycle buffers" })
vim.keymap.set("n", "<s-tab>", "<cmd>bprev<cr>", { desc = "Cycle buffers" })

-- move lines
vim.keymap.set("v", "<c-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "<c-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- add lines
vim.keymap.set("n", "<space>o", "myo<esc>`y", { desc = "Add line below" })
vim.keymap.set("n", "<space>O", "myO<esc>`y", { desc = "Add line above" })

-- format paragraph length
-- vim.keymap.set("n", "<space>z", "mygwap`y", { desc = "Format paragraph" })

-- don't copy when deleting or changing
vim.keymap.set({ "n", "x" }, "<space>d", '"_d', { desc = "Delete without copying" })
vim.keymap.set({ "n", "x" }, "<space>c", '"_c', { desc = "Change without copying" })
vim.keymap.set({ "n", "x" }, "x", '"_x', { desc = "Delete without copying" })

-- but do copy on capital x
vim.keymap.set("n", "X", "x", { desc = "Delete without copying" })

-- copy selection and delete line
vim.keymap.set("x", "D", 'd"_dd', { desc = "Copy selection and delete line" })

-- don't copy when starting insert mode on a character
vim.keymap.set("n", "s", '"_s', { desc = "Don't copy letter when pressing `s`" })

-- apply normal mode command for every line
vim.keymap.set("x", "<space>:", ":%norm ", { desc = "Execute normal mode commands on every line" })

-- replace selection on current line
local function replace_selection_on_line()
	vim.cmd('normal! "yy')
	local to_replace = strings.escape_vim(vim.fn.getreg("y"))
	vim.fn.setreg("+", to_replace)

	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes(
			"mu:s/<C-R>=escape(@y,'/\\')<CR>/<C-R>=escape(@y,'/\\')<cr>/g | :noh | :normal `u<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>",
			true,
			true,
			true
		),
		"n",
		true
	)
end

-- Map the function to 'r' in visual mode
vim.keymap.set("x", "R", replace_selection_on_line, {
	desc = "Replace selection on the current line",
})

local function replace_selection(word_boundaries)
	vim.cmd('normal! "yy')
	local to_replace = strings.escape_vim(vim.fn.getreg("y"))
	local pattern = to_replace

	if word_boundaries then
		pattern = "\\<" .. to_replace .. "\\>"
	end

	vim.api.nvim_feedkeys(
		":.,$s/"
			.. pattern
			.. "/"
			.. to_replace
			.. "/gc"
			.. vim.api.nvim_replace_termcodes("<left><left><left>", true, true, true),
		"n",
		true
	)
end

-- Replace selection without word boundaries
vim.keymap.set("x", "<space>r", function()
	replace_selection(false)
end, { desc = "Replace selection from current line to end of file (no word boundaries)" })

-- Replace selection with word boundaries
vim.keymap.set("x", "<Space>R", function()
	replace_selection(true)
end, { desc = "Replace selection from current line to end of file (with word boundaries)" })

-- merge with the next line without space in between
vim.keymap.set("n", "<space>J", 'J"_diW', { desc = "Merge with the next line" })

-- search with word boundaries
vim.keymap.set("n", "</", "/\\<\\><left><left>", { desc = "Search with word boundaries" })

-- Navigate to next line with same indentation level
vim.keymap.set("n", "<space>i", function()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local current_line = cursor[1]
	local total_lines = vim.api.nvim_buf_line_count(0)

	-- Get current line's indentation
	local line_text = vim.api.nvim_buf_get_lines(0, current_line - 1, current_line, false)[1]
	local current_indent = line_text:match("^%s*"):len()

	-- Search for next line with same indentation
	for i = current_line + 1, total_lines do
		local next_line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
		if next_line and next_line:match("%S") then -- Line has non-whitespace
			local next_indent = next_line:match("^%s*"):len()
			if next_indent == current_indent then
				-- Move to first non-whitespace character
				vim.api.nvim_win_set_cursor(0, { i, current_indent })
				return
			end
		end
	end
end, { desc = "Go to next line with same indentation" })

-- Navigate to previous line with same indentation level
vim.keymap.set("n", "<space>I", function()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local current_line = cursor[1]

	-- Get current line's indentation
	local line_text = vim.api.nvim_buf_get_lines(0, current_line - 1, current_line, false)[1]
	local current_indent = line_text:match("^%s*"):len()

	-- Search backwards for previous line with same indentation
	for i = current_line - 1, 1, -1 do
		local prev_line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
		if prev_line and prev_line:match("%S") then -- Line has non-whitespace
			local prev_indent = prev_line:match("^%s*"):len()
			if prev_indent == current_indent then
				-- Move to first non-whitespace character
				vim.api.nvim_win_set_cursor(0, { i, current_indent })
				return
			end
		end
	end
end, { desc = "Go to previous line with same indentation" })

-- vim.keymap.set("x", "<space>e", function()
-- 	local name = vim.fn.input("Variable name: ")
-- 	if name == "" then
-- 		return
-- 	end
--
-- 	vim.api.nvim_feedkeys(
-- 		vim.api.nvim_replace_termcodes('"ydha' .. name .. "<esc>O" .. name .. ' = <esc>"yp', true, false, true),
-- 		"n",
-- 		false
-- 	)
-- end, { desc = "Extract variable" })

-- NORMAL mode: join with next line, trimming leading whitespace on the next line
vim.keymap.set("n", "<Space>J", function()
	-- Replace the newline between current and next line (and any leading whitespace after it) with a single space
	vim.cmd([[silent! keeppatterns keepjumps .,+1s/\n\s*/ /]])
end, { desc = "Join with next line, trim leading whitespace", silent = true })

-- VISUAL mode: join selection with NO space, trim leading whitespace at boundaries
vim.keymap.set("x", "<Space>J", "Jdiw", { desc = "Join selection (no space), trim leading whitespace", silent = true })

-- paste on new line while indented
-- vim.keymap.set("n", "<Space>p", "o<C-r>+<Esc>", { desc = "Paste clipboard on new line (insert then paste)" })

vim.keymap.set("n", "<cr>;", function()
	local command =
		'pane_id=$(~/.scripts/find_pane_id.sh run); tmux send-keys -t $pane_id -X cancel || true; tmux send-keys -t $pane_id "C-l"; sleep 0.1; tmux clear-history -t $pane_id'
	vim.fn.system(command)
end)

vim.keymap.set("x", "<CR>", function()
	-- get selection line range
	local pos1 = vim.fn.getpos("v")[2]
	local pos2 = vim.fn.getpos(".")[2]
	local start_line = math.min(pos1, pos2)
	local end_line = math.max(pos1, pos2)

	-- read selected lines
	local lines = vim.fn.getline(start_line, end_line)

	-- compute minimum indent (ignore blank lines)
	local min_indent = nil
	for _, line in ipairs(lines) do
		local indent = line:match("^%s*"):len()
		if line:match("%S") then
			min_indent = min_indent and math.min(min_indent, indent) or indent
		end
	end
	min_indent = min_indent or 0

	-- strip indent
	local cleaned = {}
	for _, line in ipairs(lines) do
		table.insert(cleaned, line:sub(min_indent + 1))
	end

	-- join
	local text = table.concat(cleaned, "\n")

	-- ESCAPE FOR TMUX:
	-- 1. Escape backslashes
	-- 2. Escape double quotes
	text = text:gsub("\\", "\\\\"):gsub('"', '\\"')

	local cmd = string.format(
		[[
bash -lc '
pane_id=$(~/.scripts/find_pane_id.sh run)
tmux send-keys -t $pane_id -X cancel || true
sleep 0.05
tmux send-keys -t $pane_id "%s" "Enter"
'
]],
		text
	)

	vim.fn.system(cmd)
end, { desc = "Send deindented visual selection to tmux" })

vim.keymap.set("n", "<CR><CR>", function()
	-- current line
	local line = vim.api.nvim_get_current_line()

	-- deindent: remove all leading whitespace (spaces/tabs)
	local text = line:gsub("^%s+", "")

	-- if the line is empty after trimming, do nothing
	if text == "" then
		return
	end

	-- ESCAPE FOR TMUX + shell (since we're wrapping in bash -lc and double-quotes):
	-- 1) backslashes
	-- 2) double quotes
	-- 3) $ (prevents variable expansion)
	-- 4) backticks (prevents command substitution)
	text = text:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("%$", "\\$"):gsub("`", "\\`")

	local cmd = string.format(
		[[
bash -lc '
pane_id=$(~/.scripts/find_pane_id.sh run)
tmux send-keys -t $pane_id -X cancel || true
sleep 0.05
tmux send-keys -t $pane_id "%s" "Enter"
'
]],
		text
	)

	vim.fn.system(cmd)
end, { desc = "Send current line (deindented) to tmux pane run" })

vim.keymap.set("n", "<CR>k", function()
	local cmd = [[
bash -lc '
pane_id=$(~/.scripts/find_pane_id.sh run)
tmux send-keys -t $pane_id -X cancel || true
tmux send-keys -t $pane_id "Up" "Enter"
'
]]

	vim.fn.system(cmd)
end, { desc = "Run previous command in tmux pane run" })

vim.keymap.set("x", "<space>s", function()
	local prefix = vim.fn.input("Prefix: ")
	local suffix = vim.fn.input("Suffix: ")
	local keys = vim.api.nvim_replace_termcodes("I" .. prefix .. "<Esc>A" .. suffix, true, false, true)
	vim.cmd(":'<,'>normal! " .. keys)
end, { desc = "Surround every line with prefix and suffix" })

vim.keymap.set("i", "<c-^>", "<esc><c-^>", { desc = "Previous file"})
