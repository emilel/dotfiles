-- Windows and the quickfix list.

-- focus an adjacent window
vim.keymap.set("n", "<space>h", "<cmd>wincmd h<cr>", { desc = "Focus window left" })
vim.keymap.set("n", "<space>j", "<cmd>wincmd j<cr>", { desc = "Focus window below" })
vim.keymap.set("n", "<space>k", "<cmd>wincmd k<cr>", { desc = "Focus window above" })
vim.keymap.set("n", "<space>l", "<cmd>wincmd l<cr>", { desc = "Focus window right" })

-- collapse to a single window
vim.keymap.set("n", "<c-f>", "<cmd>only<cr>", { desc = "Make full screen" })

-- quickfix list
vim.keymap.set("n", "<space><c-q>", "<cmd>copen<cr><cmd>wincmd k<cr>", { desc = "Open quickfix list" })
vim.keymap.set("n", "<c-j>", "<cmd>cnext<cr>", { desc = "Next item in quickfix" })
vim.keymap.set("n", "<c-k>", "<cmd>cprev<cr>", { desc = "Previous item in quickfix" })
