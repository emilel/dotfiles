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

	it("keeps only the first hunk of each file", function()
		local a1, a2, b = { bufnr = 1, lnum = 3 }, { bufnr = 1, lnum = 9 }, { bufnr = 2, lnum = 5 }
		assert.are.same({ a1, b }, githunks.first_per_file({ a1, a2, b }))
	end)

	it("dedupes filename items independently of bufnr items", function()
		local buf, file1, file2 = { bufnr = 1 }, { filename = "new.txt" }, { filename = "new.txt" }
		assert.are.same({ buf, file1 }, githunks.first_per_file({ buf, file1, file2 }))
	end)
end)
