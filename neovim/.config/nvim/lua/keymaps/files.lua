-- Files, buffers and file-related info.
local scratch = require("lib.scratch")

-- save / close
vim.keymap.set("n", "<c-space>", "<cmd>write<cr>", { desc = "Save file" })
vim.keymap.set("n", "<space>w", "<cmd>bd<cr>", { desc = "Close buffer" })
vim.keymap.set("n", "<space>W", "<cmd>bd!<cr>", { desc = "Force close buffer" })
vim.keymap.set("n", "<space>q", "<cmd>q<cr>", { desc = "Close Neovim" })
vim.keymap.set("n", "<space>Q", "<cmd>q!<cr>", { desc = "Force close Neovim" })

-- move between buffers / files
vim.keymap.set("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<s-tab>", "<cmd>bprev<cr>", { desc = "Previous buffer" })
vim.keymap.set("i", "<c-^>", "<esc><c-^>", { desc = "Previous file" })

-- scratch buffer (<cr><cr> copies it to the clipboard and closes)
vim.keymap.set("n", "<space>b", function()
	scratch.scratch({})
end, { desc = "Open scratch buffer" })

-- file info
vim.keymap.set("n", "<C-t>", "<C-g>", { noremap = true, silent = true, desc = "Print current path" })
vim.keymap.set("n", "<space><C-t>", function()
	local file = vim.fn.expand("%")
	print(
		"Last modified: "
			.. os.date("%Y-%m-%d %H:%M:%S", vim.fn.getftime(file))
			.. ", File size: "
			.. vim.fn.getfsize(file)
			.. " bytes"
	)
end, { noremap = true, silent = true, desc = "Print last modification time and size" })

-- misc editor toggles
vim.keymap.set("n", "<space>T", ":set filetype=", { desc = "Set filetype" })
vim.keymap.set("n", "<space>M", "<cmd>set mouse=<cr>", { desc = "Disable mouse" })
