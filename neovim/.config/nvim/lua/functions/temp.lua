local temp = {}

temp.create_temporary_yank_buffer = function(arg)
	local filetype = arg or "markdown"
	vim.cmd([[execute "edit " . system("mktemp") | set filetype=]] .. filetype)
	vim.keymap.set('n', '<c-space>', 'gg0vG$y:w<cr>:bp<cr>', { buffer = true })
    print("Copied content to clipboard")
end

return temp
