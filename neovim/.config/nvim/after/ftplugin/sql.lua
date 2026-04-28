vim.keymap.set("n", "<CR>r", function()
	local file = vim.fn.expand("%") -- absolute path of current buffer
	local cmd = string.format(
		[[
bash -lc '
pane_id=$(~/.scripts/find_pane_id.sh run)
tmux send-keys -t $pane_id -X cancel || true
sleep 0.1
tmux send-keys -t $pane_id "py scripts/sql.py %s" "Enter"
']],
		file
	)
	vim.fn.system(cmd)
end, { buffer = true, desc = "Run py scripts/sql.py <path> in tmux pane run" })

vim.keymap.set("n", "<CR>R", function()
	local file = vim.fn.expand("%") -- absolute path of current buffer
	local cmd = string.format(
		[[
bash -lc '
pane_id=$(~/.scripts/find_pane_id.sh run)
tmux send-keys -t $pane_id -X cancel || true
sleep 0.1
tmux send-keys -t $pane_id "py scripts/sql_cached.py %s" "Enter"
']],
		file
	)
	vim.fn.system(cmd)
end, { buffer = true, desc = "Run py scripts/sql_cached.py <path> in tmux pane run" })
