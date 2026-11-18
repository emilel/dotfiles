-- :edit on an image hands it to the viewer and puts back the buffer you were in.
require("core.autocmds")

describe("media files", function()
	local opened, real_open
	before_each(function()
		opened = {}
		real_open = vim.ui.open
		vim.ui.open = function(path)
			table.insert(opened, path)
			return {}, nil
		end
	end)
	after_each(function()
		vim.ui.open = real_open
	end)

	it("opens images externally and returns to the previous buffer", function()
		local dir = vim.fn.tempname()
		vim.fn.mkdir(dir, "p")
		vim.fn.writefile({ "hello" }, dir .. "/notes.txt")
		vim.fn.writefile({}, dir .. "/IMG_1.JPG")

		vim.cmd.edit(dir .. "/notes.txt")
		local notes = vim.api.nvim_get_current_buf()
		vim.cmd.edit(dir .. "/IMG_1.JPG")
		vim.wait(100, function()
			return vim.api.nvim_get_current_buf() == notes
		end)

		assert.are.same({ dir .. "/IMG_1.JPG" }, opened)
		assert.are.equal(notes, vim.api.nvim_get_current_buf())
		assert.are.equal(-1, vim.fn.bufnr(dir .. "/IMG_1.JPG"))
	end)

	it("leaves text files in nvim", function()
		local f = vim.fn.tempname() .. ".txt"
		vim.fn.writefile({ "hello" }, f)
		vim.cmd.edit(f)
		assert.are.same({}, opened)
		assert.are.same({ "hello" }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
	end)
end)
