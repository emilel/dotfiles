-- LSP references minus the ones that only re-plumb a name: imports and
-- `__all__` entries. What's left is where the symbol is actually used.
local M = {}

local imports = {
	import_statement = true,
	import_from_statement = true,
	future_import_statement = true,
}

-- True when (row, col), 0-based, sits in an import or an `__all__` statement
-- (`= [...]`, `+= [...]`, `.extend(...)`). `source` is a bufnr or a string.
M.is_plumbing = function(source, lang, row, col)
	local ok, parser = pcall(function()
		return type(source) == "string" and vim.treesitter.get_string_parser(source, lang)
			or vim.treesitter.get_parser(source, lang)
	end)
	if not ok or not parser then
		return false
	end
	local node = parser:parse()[1]:root():named_descendant_for_range(row, col, row, col)
	while node do
		local t = node:type()
		if imports[t] then
			return true
		end
		if t == "expression_statement" and vim.treesitter.get_node_text(node, source):match("^__all__[%s.:+=]") then
			return true
		end
		node = node:parent()
	end
	return false
end

-- Quickfix items from vim.lsp's on_list, filtered. Each file is read once:
-- from its buffer when loaded (unsaved edits count), else from disk, so no
-- buffer gets opened just to be checked.
M.usages = function(items)
	local sources = {}
	return vim.tbl_filter(function(item)
		local file = item.filename
		if sources[file] == nil then
			local buf = vim.fn.bufnr(file)
			local src = vim.api.nvim_buf_is_loaded(buf) and buf or table.concat(vim.fn.readfile(file), "\n")
			local ft = vim.filetype.match({ filename = file, buf = type(src) == "number" and src or nil })
			local lang = ft and vim.treesitter.language.get_lang(ft)
			sources[file] = lang and { src, lang } or false
		end
		local s = sources[file]
		return not (s and M.is_plumbing(s[1], s[2], item.lnum - 1, item.col - 1))
	end, items)
end

M.references = function()
	vim.lsp.buf.references(nil, {
		on_list = function(t)
			t.items = M.usages(t.items)
			if #t.items == 0 then
				return vim.notify("No usages outside imports and __all__", vim.log.levels.INFO)
			end
			vim.fn.setqflist({}, " ", t)
			vim.cmd("botright copen")
		end,
	})
end

return M
