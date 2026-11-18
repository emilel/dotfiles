local references = require("lib.references")

local src = table.concat({
	"from pkg import foo",
	"from pkg import (",
	"    foo as bar,",
	")",
	"import foo",
	'__all__ = ["foo"]',
	'__all__ += ["foo"]',
	'__all__.extend(["foo"])',
	"foo()",
	"x = foo",
}, "\n")

local function plumbing(row, col)
	return references.is_plumbing(src, "python", row, col)
end

describe("lib.references", function()
	if not pcall(vim.treesitter.language.add, "python") then
		pending("python parser not installed")
		return
	end

	it("drops imports, single- and multi-line", function()
		assert.is_true(plumbing(0, 16))
		assert.is_true(plumbing(2, 4))
		assert.is_true(plumbing(4, 7))
	end)

	it("drops __all__ entries", function()
		assert.is_true(plumbing(5, 12))
		assert.is_true(plumbing(6, 13))
		assert.is_true(plumbing(7, 17))
	end)

	it("keeps real usages", function()
		assert.is_false(plumbing(8, 0))
		assert.is_false(plumbing(9, 4))
	end)

	it("filters quickfix items read from disk", function()
		local file = vim.fn.tempname() .. ".py"
		vim.fn.writefile(vim.split(src, "\n"), file)
		local items = {
			{ filename = file, lnum = 1, col = 17 },
			{ filename = file, lnum = 9, col = 1 },
			{ filename = file, lnum = 6, col = 13 },
		}
		assert.are.same({ items[2] }, references.usages(items))
	end)
end)
