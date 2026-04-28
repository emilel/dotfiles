local yank = require("functions.yank")

vim.keymap.set("n", "\\st", 'o__import__("ipdb").set_trace()<esc>', { buffer = true, desc = "Set trace" })
vim.keymap.set("n", "\\l", 'my<cmd>g/__import__("ipdb").set_trace()/d<cr>\'y', { buffer = true, desc = "Clear trace" })
vim.keymap.set("n", "\\e", 'o__import__("sys").exit(-1)<esc>', { buffer = true, desc = "Exit" })
vim.keymap.set("x", "\\a", '"yy<esc>oprint(f"")<esc>h"yPa: {}<esc>"yPV', { buffer = true, desc = "Print expression" })
vim.opt_local.textwidth = 120

vim.keymap.set("n", "<CR>r", function()
	local file = vim.fn.expand("%")
	local cmd = string.format(
		[[
bash -lc '
pane_id=$(~/.scripts/find_pane_id.sh run)
tmux send-keys -t $pane_id -X cancel || true
sleep 0.1
tmux send-keys -t $pane_id "py %s" "Enter"
']],
		file
	)
	vim.fn.system(cmd)
end, { buffer = true, desc = "Run py <path> in tmux pane run" })

vim.keymap.set("n", "<CR>R", function()
	local file = vim.fn.expand("%")
	local cmd = string.format(
		[[
bash -lc '
pane_id=$(~/.scripts/find_pane_id.sh run)
tmux send-keys -t $pane_id -X cancel || true
sleep 0.1
tmux send-keys -t $pane_id "py %s "
tmux select-pane -t $pane_id
']],
		file
	)
	vim.fn.system(cmd)
end, { buffer = true, desc = "Run py <path> with arguments in tmux pane run" })

vim.keymap.set("n", "<CR>i", function()
	local file = vim.fn.expand("%") -- absolute path of current buffer
	local cmd = string.format(
		[[
bash -lc '
pane_id=$(~/.scripts/find_pane_id.sh run)
tmux send-keys -t $pane_id -X cancel || true
sleep 0.1
tmux send-keys -t $pane_id "py -i %s" "Enter"
']],
		file
	)
	vim.fn.system(cmd)
end, { buffer = true, desc = "Run py -i <path> in tmux pane run" })


vim.keymap.set("n", "<space>N", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local filetype = vim.bo.filetype
	yank.open_buffer()
	vim.bo.filetype = filetype
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end, { desc = "Open temporary python file" })

vim.keymap.set("n", "<cr>s", function ()
	local variable = vim.fn.expand("<cword>")
	local cmd = string.format(
		[[
bash -lc '
pane_id=$(~/.scripts/find_pane_id.sh run)
tmux send-keys -t $pane_id -X cancel || true
sleep 0.1
tmux send-keys -t $pane_id "%s.show()" "Enter"
']],
		variable
	)
	vim.fn.system(cmd)
end)

vim.keymap.set("n", "<cr>S", function ()
	local variable = vim.fn.expand("<cword>")
	local cmd = string.format(
		[[
bash -lc '
pane_id=$(~/.scripts/find_pane_id.sh run)
tmux send-keys -t $pane_id -X cancel || true
sleep 0.1
tmux send-keys -t $pane_id "%s.show(truncate=False)" "Enter"
']],
		variable
	)
	vim.fn.system(cmd)
end)

vim.keymap.set("n", "<cr>c", function ()
	local variable = vim.fn.expand("<cword>")
	local cmd = string.format(
		[[
bash -lc '
pane_id=$(~/.scripts/find_pane_id.sh run)
tmux send-keys -t $pane_id -X cancel || true
sleep 0.1
tmux send-keys -t $pane_id "%s.count()" "Enter"
']],
		variable
	)
	vim.fn.system(cmd)
end)
