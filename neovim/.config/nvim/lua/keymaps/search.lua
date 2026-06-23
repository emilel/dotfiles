-- Searching: set the search register without jumping, extend it, word boundaries.
local strings = require("lib.strings")
local search = require("lib.search")

local function set_search(pattern)
	vim.o.hlsearch = true
	vim.fn.setreg("/", pattern)
end

-- * : highlight the word/selection under the cursor without jumping to it
vim.keymap.set("n", "*", function()
	set_search(search.word_pattern(vim.fn.expand("<cword>")))
end, { desc = "Highlight word under cursor (no jump)" })

vim.keymap.set("x", "*", function()
	vim.cmd('normal! "yy')
	local term = strings.escape_vim(vim.fn.getreg("y"))
	set_search(search.multiline_pattern(term))
end, { desc = "Highlight selection (no jump)" })

-- ? : type a search pattern straight into the search register (no jump)
vim.keymap.set("n", "?", function()
	set_search(vim.fn.input("?"))
end, { desc = "Set search without jumping" })

-- <space>? : reopen the current search for editing
vim.keymap.set("n", "<space>?", function()
	vim.api.nvim_feedkeys("/" .. vim.fn.getreg("/"), "n", false)
end, { desc = "Edit current search" })

-- extend the current search with the selection / word under cursor
vim.keymap.set("x", "<space>/", function()
	vim.api.nvim_feedkeys('"yy', "x", false)
	local term = strings.escape_vim(vim.fn.getreg("y"))
	vim.fn.setreg("/", search.append(vim.fn.getreg("/"), term))
end, { desc = "Append selection to search" })

vim.keymap.set("n", "<space><space>*", function()
	local term = strings.escape_vim(vim.fn.expand("<cword>"))
	vim.fn.setreg("/", search.append_word(vim.fn.getreg("/"), term))
end, { desc = "Append word to search" })

-- start a search pre-wrapped in word boundaries
vim.keymap.set("n", "</", "/\\<\\><left><left>", { desc = "Search with word boundaries" })
