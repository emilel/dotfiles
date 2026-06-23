local strings = require("lib.strings")

describe("lib.strings", function()
	it("escapes vim regex specials", function()
		assert.are.equal("a\\.b", strings.escape_vim("a.b"))
		assert.are.equal("a\\*b", strings.escape_vim("a*b"))
		assert.are.equal("a\\/b", strings.escape_vim("a/b"))
	end)

	it("leaves plain text untouched", function()
		assert.are.equal("hello", strings.escape_vim("hello"))
		assert.are.equal("hello", strings.escape_pcre("hello"))
	end)

	it("escapes pcre specials", function()
		assert.are.equal("a\\.b\\*c", strings.escape_pcre("a.b*c"))
		assert.are.equal("\\(x\\)", strings.escape_pcre("(x)"))
	end)
end)
