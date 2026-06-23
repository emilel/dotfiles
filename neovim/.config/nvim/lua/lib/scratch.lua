-- Throwaway "scratch" buffers. Used by the :Clip / :TempFile / :Pipe commands
-- (and their `clip` / `temp` / `edit` shell helpers) and by <space>b, <space>+
-- and python's <space>N. The shared idea: <cr><cr> finishes and closes.
--
-- Scratch buffers are kept on disk under a dedicated directory, named by
-- creation time, so you can browse them and reopen content after closing.
-- /tmp is cleared on reboot, which is the intended lifetime.
local M = {}

local dir = "/tmp/nvim-scratch"

-- filetype -> extension, so reopened files keep their highlighting. Filetypes
-- not listed use their own name as the extension (lua, json, sql, yaml, ...).
local extensions = {
	markdown = "md",
	python = "py",
	bash = "sh",
	javascript = "js",
	typescript = "ts",
}

-- Open a scratch buffer backed by /tmp/nvim-scratch/<timestamp>.<ext>. On
-- <cr><cr> it copies the buffer to the clipboard, saves the file and closes.
--   opts.filetype  set the filetype (and pick the file extension)
--   opts.content   prefill text, e.g. the clipboard or the current buffer
--   opts.close     ex-command run on exit. Default "bdelete!" (in-editor);
--                  use "quit!" to exit a standalone `nvim +Clip` / `+TempFile`.
function M.scratch(opts)
	opts = opts or {}
	vim.fn.mkdir(dir, "p")
	local ext = opts.filetype and (extensions[opts.filetype] or opts.filetype) or "txt"
	local path = string.format("%s/%s.%s", dir, os.date("%Y-%m-%d_%H-%M-%S"), ext)

	vim.cmd("edit " .. vim.fn.fnameescape(path))
	vim.opt_local.signcolumn = "no"
	vim.diagnostic.enable(false, { bufnr = 0 })
	if opts.filetype then
		vim.bo.filetype = opts.filetype
	end
	if opts.content then
		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split((opts.content:gsub("\n$", "")), "\n"))
	end

	local close = opts.close or "bdelete!"
	vim.keymap.set("n", "<cr><cr>", function()
		vim.fn.setreg("+", table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"))
		vim.cmd("silent write")
		vim.cmd(close)
	end, { buffer = true, desc = "Copy to clipboard, save and close" })
end

-- Edit an existing file; <cr><cr> writes it and quits, so its contents flow
-- back out. Used by the `edit` shell filter (stdin -> nvim -> stdout) via :Pipe.
function M.pipe(path)
	vim.cmd("edit " .. vim.fn.fnameescape(path))
	vim.keymap.set("n", "<cr><cr>", "<cmd>wq!<cr>", { buffer = true, desc = "Save and quit" })
end

return M
