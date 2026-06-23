local scratch = require("lib.scratch")

vim.keymap.set("n", "\\st", 'o__import__("ipdb").set_trace()<esc>', { buffer = true, desc = "Set trace" })
vim.keymap.set("n", "\\l", 'my<cmd>g/__import__("ipdb").set_trace()/d<cr>\'y', { buffer = true, desc = "Clear trace" })
vim.keymap.set("n", "\\e", 'o__import__("sys").exit(-1)<esc>', { buffer = true, desc = "Exit" })
vim.keymap.set("x", "\\a", '"yy<esc>oprint(f"")<esc>h"yPa: {}<esc>"yPV', { buffer = true, desc = "Print expression" })
vim.opt_local.textwidth = 120

vim.keymap.set("n", "<space>N", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local filetype = vim.bo.filetype
	scratch.open_buffer()
	vim.bo.filetype = filetype
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end, { desc = "Open temporary python file" })
