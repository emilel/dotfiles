local replace = require("lib.replace")

describe("lib.replace", function()
	it("builds a range substitute to EOF", function()
		assert.are.equal(":.,$s/foo/bar/gc", replace.range_substitute("foo", "bar"))
	end)

	it("derives the cursor offset for the range substitute", function()
		-- length of "/gc" -> lands the cursor at the end of the replacement field
		assert.are.equal(3, replace.range_lefts())
	end)

	it("builds a current-line substitute", function()
		assert.are.equal("mu:s/X/X/g | :noh | :normal `u", replace.line_substitute("X"))
	end)

	it("derives the cursor offset for the line substitute (was the magic 22)", function()
		assert.are.equal(22, replace.line_lefts())
	end)
end)
