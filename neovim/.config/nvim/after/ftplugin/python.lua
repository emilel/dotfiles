vim.keymap.set("n", "\\st", 'o__import__("ipdb").set_trace()<esc>', { buffer = true, desc = "Set trace" })
vim.keymap.set("n", "\\l", 'my<cmd>g/__import__("ipdb").set_trace()/d<cr>\'y', { buffer = true, desc = "Clear trace" })
vim.keymap.set("n", "\\e", 'o__import__("sys").exit(-1)<esc>', { buffer = true, desc = "Exit" })
vim.keymap.set("x", "\\a", '"yy<esc>oprint(f"")<esc>h"yPa: {}<esc>"yPV', { buffer = true, desc = "Exit" })
