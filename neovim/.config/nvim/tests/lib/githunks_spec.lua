local githunks = require("lib.githunks")

describe("lib.githunks", function()
	it("picks out intent-to-add files", function()
		local records = { " A new.txt", " M edited.txt", "?? untracked.txt", "A  staged.txt" }
		assert.are.same({ "new.txt" }, githunks.intent_to_add(records))
	end)

	it("keeps paths with spaces intact", function()
		assert.are.same({ "a dir/my file.txt" }, githunks.intent_to_add({ " A a dir/my file.txt" }))
	end)

	it("ignores the trailing empty record from -z output", function()
		assert.are.same({}, githunks.intent_to_add({ " M a.txt", "" }))
	end)

	it("ignores staged adds that were later modified", function()
		-- `AM` is worktree-modified, so gitsigns already lists it.
		assert.are.same({}, githunks.intent_to_add({ "AM both.txt", "MM other.txt" }))
	end)
end)
