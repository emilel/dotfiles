-- Text editing: selecting, deleting/changing, moving lines, joining, replacing.
local strings = require("lib.strings")
local replace = require("lib.replace")

-- keep visual selection when indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left, keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right, keep selection" })

-- selecting
vim.keymap.set("n", "<space>v", "^v$h", { desc = "Select line" })
vim.keymap.set("n", "<space>V", "gg0VG", { desc = "Select entire file" })
vim.keymap.set("n", "gp", "`[v`]", { desc = "Select pasted text" })

-- keep the cursor still after yanking a visual selection
vim.keymap.set("x", "y", "ygv<esc>", { desc = "Keep cursor when copying selection" })
vim.keymap.set("x", "L", "$h", { desc = "Go to end of line" })

-- run the q macro / insert a markdown code block
vim.keymap.set("n", "Q", "@q", { desc = "Run q macro" })
vim.keymap.set("n", "<space>``", "a```<cr>```<esc>k$", { desc = "Insert codeblock" })

-- move lines up/down in visual mode
vim.keymap.set("v", "<c-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "<c-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- add a blank line without moving the cursor
vim.keymap.set("n", "<space>o", "myo<esc>`y", { desc = "Add line below" })
vim.keymap.set("n", "<space>O", "myO<esc>`y", { desc = "Add line above" })

-- delete / change without clobbering the yank register
vim.keymap.set({ "n", "x" }, "<space>d", '"_d', { desc = "Delete without copying" })
vim.keymap.set({ "n", "x" }, "<space>c", '"_c', { desc = "Change without copying" })
vim.keymap.set({ "n", "x" }, "x", '"_x', { desc = "Delete char without copying" })
vim.keymap.set("n", "X", "x", { desc = "Delete char (and copy)" })
vim.keymap.set("x", "D", 'd"_dd', { desc = "Copy selection and delete line" })
vim.keymap.set("n", "s", '"_s', { desc = "Substitute char without copying" })

-- run a normal-mode command on every selected line
vim.keymap.set("x", "<space>:", ":%norm ", { desc = "Run normal command on every line" })

-- replace the visual selection on the current line (review before <cr>)
vim.keymap.set("x", "R", function()
	vim.cmd('normal! "yy')
	vim.fn.setreg("+", strings.escape_vim(vim.fn.getreg("y")))
	-- escape(@y,'/\') is inserted live via the expression register so the search
	-- and replacement fields match the selection literally.
	local expr = [[<C-R>=escape(@y,'/\')<CR>]]
	local cmdline = replace.line_substitute(expr) .. string.rep("<left>", replace.line_lefts())
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmdline, true, true, true), "n", true)
end, { desc = "Replace selection on the current line" })

-- replace the visual selection from the current line to EOF (review before <cr>)
local function replace_selection(word_boundaries)
	vim.cmd('normal! "yy')
	local to_replace = strings.escape_vim(vim.fn.getreg("y"))
	local pattern = word_boundaries and ("\\<" .. to_replace .. "\\>") or to_replace
	local cmdline = replace.range_substitute(pattern, to_replace)
		.. vim.api.nvim_replace_termcodes(string.rep("<left>", replace.range_lefts()), true, true, true)
	vim.api.nvim_feedkeys(cmdline, "n", true)
end

vim.keymap.set("x", "<space>r", function()
	replace_selection(false)
end, { desc = "Replace selection to EOF (no word boundaries)" })
vim.keymap.set("x", "<Space>R", function()
	replace_selection(true)
end, { desc = "Replace selection to EOF (with word boundaries)" })

-- join with the next line WITHOUT a space, trimming its leading whitespace
-- (plain J already joins WITH a space, so that is the non-default behaviour)
vim.keymap.set("n", "<space>J", function()
	vim.cmd([[silent! keeppatterns keepjumps .,+1s/\n\s*//]])
end, { desc = "Join next line (no space), trim whitespace", silent = true })
vim.keymap.set("x", "<space>J", "Jdiw", { desc = "Join selection (no space), trim whitespace", silent = true })

-- surround every selected line with a prefix and suffix
vim.keymap.set("x", "<space>s", function()
	local prefix = vim.fn.input("Prefix: ")
	local suffix = vim.fn.input("Suffix: ")
	local keys = vim.api.nvim_replace_termcodes("I" .. prefix .. "<Esc>A" .. suffix, true, false, true)
	vim.cmd(":'<,'>normal! " .. keys)
end, { desc = "Surround every line with prefix and suffix" })
