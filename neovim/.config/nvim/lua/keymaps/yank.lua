-- Copying things to the system clipboard: file content, paths, git metadata,
-- fenced code blocks, and an appending "collector" register.
local paths = require("lib.paths")
local scratch = require("lib.scratch")

-- copy the whole buffer to register +, keeping the file name / path as context
local function copy_file_with_header(header)
	local filetype = vim.bo.filetype
	local scroll_pos = vim.fn.winsaveview()
	vim.cmd("normal! gg0yG")
	vim.fn.winrestview(scroll_pos)
	local file_content = vim.fn.getreg('"')
	vim.fn.setreg("+", string.format("%s:\n\n```%s\n%s\n```", header, filetype, file_content))
	print("Copied '" .. header .. "' and " .. #vim.fn.split(file_content, "\n") .. " lines")
end

-- copy + print a single piece of metadata
local function copy(value)
	vim.fn.setreg("+", value)
	print("Copied: " .. value)
end

-- content -------------------------------------------------------------------
vim.keymap.set("n", "<space>yy", "my^y$`y", { desc = "Copy line content" })

vim.keymap.set("n", "<space>yf", function()
	local scroll_pos = vim.fn.winsaveview()
	vim.cmd("normal gg0yG")
	vim.fn.winrestview(scroll_pos)
end, { desc = "Copy entire file" })

vim.keymap.set("n", "<space>yN", function()
	copy_file_with_header(paths.get_file_name())
end, { desc = "Copy file name and content" })

vim.keymap.set("n", "<space>yF", function()
	copy_file_with_header(paths.get_relative_path())
end, { desc = "Copy relative path and content" })

-- paths / names -------------------------------------------------------------
vim.keymap.set("n", "<space>yp", function()
	copy(paths.get_relative_path())
end, { desc = "Copy relative path" })
vim.keymap.set("n", "<space>yP", function()
	copy(paths.get_absolute_path())
end, { desc = "Copy full path" })
vim.keymap.set("n", "<space>yn", function()
	copy(paths.get_file_name())
end, { desc = "Copy file name" })
vim.keymap.set("n", "<space>yd", function()
	copy(paths.get_relative_directory())
end, { desc = "Copy relative directory" })
vim.keymap.set("n", "<space>yD", function()
	copy(paths.get_absolute_directory())
end, { desc = "Copy absolute directory" })

-- git -----------------------------------------------------------------------
vim.keymap.set("n", "<space>yb", function()
	copy(paths.get_git_branch())
end, { desc = "Copy branch name" })
vim.keymap.set("n", "<space>yr", function()
	copy(paths.get_repo_name())
end, { desc = "Copy repository name" })

-- locations (path + line) ---------------------------------------------------
vim.keymap.set("n", "<space>yl", function()
	copy(string.format("%s:%d", paths.get_file_name(), paths.get_line()))
end, { desc = "Copy file name and line number" })
vim.keymap.set("n", "<space>yg", function()
	copy(string.format("break %s:%d", paths.get_file_name(), paths.get_line()))
end, { desc = "Copy gdb breakpoint command" })
vim.keymap.set("n", "<space>yL", function()
	copy(string.format("%s:%d", paths.get_relative_to_repo_path(), paths.get_line()))
end, { desc = "Copy repo path and line number" })
vim.keymap.set("n", "<space>ye", function()
	copy(string.format("%s@%s %s", paths.get_repo_name(), paths.get_git_branch(), paths.get_relative_to_repo_path()))
end, { desc = "Copy repository, branch and file" })
vim.keymap.set("n", "<space>yE", function()
	copy(
		string.format(
			"%s@%s %s:%d",
			paths.get_repo_name(),
			paths.get_git_branch(),
			paths.get_relative_to_repo_path(),
			paths.get_line()
		)
	)
end, { desc = "Copy repository, branch, file and line number" })

-- append the selection/line to register + (a running collector)
vim.keymap.set("x", "Y", function()
	local mode = vim.fn.mode()
	vim.cmd('normal! "yy')
	local selected_text = vim.fn.getreg("y")
	local current_clipboard = vim.fn.getreg("+")

	local new_clipboard_content
	if mode:sub(1, 1) == "v" then
		vim.cmd('normal! "y')
		new_clipboard_content = current_clipboard .. "\n" .. selected_text
	else
		vim.cmd('normal! "yy')
		new_clipboard_content = current_clipboard .. selected_text
	end
	vim.fn.setreg("+", new_clipboard_content)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gv<esc>", true, true, true), "n", true)
end, { desc = "Append selection to clipboard register" })

-- edit the clipboard in a scratch buffer with the current filetype
vim.keymap.set("n", "<space>+", function()
	scratch.scratch({ filetype = vim.bo.filetype, content = vim.fn.getreg("+") })
end, { desc = "Edit clipboard in a scratch buffer" })

-- copy the selection as a fenced code block
vim.keymap.set("x", "<space>y", function()
	local ft = vim.bo.filetype
	vim.cmd("normal! y")
	local content = vim.fn.getreg('"'):gsub("\n$", "") -- drop one trailing newline
	vim.fn.setreg("+", string.format("```%s\n%s\n```", ft, content))
	print("Copied " .. #vim.fn.split(content, "\n") .. " fenced lines")
end, { desc = "Copy selection as a fenced code block" })
