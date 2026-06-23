local search = require("lib.search")

describe("lib.search", function()
	it("wraps words in boundaries", function()
		assert.are.equal("\\<foo\\>", search.word_pattern("foo"))
	end)

	it("appends to an existing search", function()
		assert.are.equal("a\\|b", search.append("a", "b"))
		assert.are.equal("a\\|\\<b\\>", search.append_word("a", "b"))
	end)

	it("returns a single line verbatim", function()
		assert.are.equal("foo", search.multiline_pattern("foo"))
	end)

	it("joins multiple lines with whitespace-tolerant separators", function()
		assert.are.equal("\\s*foo\\n\\s*bar", search.multiline_pattern("  foo\n   bar"))
	end)

	it("drops a spurious trailing empty line", function()
		-- no trailing newline -> only the two real lines survive
		assert.are.equal("\\s*foo\\n\\s*bar", search.multiline_pattern("foo\nbar"))
	end)
end)
