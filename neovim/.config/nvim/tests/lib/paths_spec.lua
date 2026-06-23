local paths = require("lib.paths")

describe("lib.paths", function()
	it("extracts the basename of a path", function()
		assert.are.equal("c.lua", paths.basename("/a/b/c.lua"))
		assert.are.equal("file", paths.basename("file"))
		assert.are.equal("x", paths.basename("/a/b/x"))
	end)

	it("reads the file name of the current buffer", function()
		vim.api.nvim_buf_set_name(0, "/tmp/example/widget.py")
		assert.are.equal("widget.py", paths.get_file_name())
	end)
end)
