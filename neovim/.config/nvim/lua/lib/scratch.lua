-- Throwaway "scratch" buffers. Used by the :Clip / :TempFile / :Pipe commands
-- (and their `clip` / `temp` / `edit` shell helpers) and by <space>b, <space>+
-- and python's <space>N. The shared idea: <cr><cr> finishes and closes.
local M = {}

-- Open an empty buffer backed by a temp file (never written to disk). On
-- <cr><cr> it copies the whole buffer to the system clipboard and closes.
--   opts.filetype  set the filetype (highlighting / formatting)
--   opts.content   prefill text, e.g. the clipboard or the current buffer
--   opts.close     ex-command run on exit. Default "bdelete!" (in-editor);
--                  use "quit!" to exit a standalone `nvim +Clip` / `+TempFile`.
function M.scratch(opts)
	opts = opts or {}
	vim.cmd("edit " .. vim.fn.tempname())
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
		vim.cmd(close)
	end, { buffer = true, desc = "Copy buffer to clipboard and close" })
end

-- Edit an existing file; <cr><cr> writes it and quits, so its contents flow
-- back out. Used by the `edit` shell filter (stdin -> nvim -> stdout) via :Pipe.
function M.pipe(path)
	vim.cmd("edit " .. vim.fn.fnameescape(path))
	vim.keymap.set("n", "<cr><cr>", "<cmd>wq!<cr>", { buffer = true, desc = "Save and quit" })
end

return M
