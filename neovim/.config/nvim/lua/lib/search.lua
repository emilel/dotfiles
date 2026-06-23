-- Pure builders for Vim search patterns. No editor state -> unit-testable.
-- Callers are responsible for escaping the raw text (see lib.strings.escape_vim)
-- before handing it to multiline_pattern / append.
local M = {}

-- Wrap a (already escaped) word in Vim word boundaries: foo -> \<foo\>
M.word_pattern = function(word)
	return "\\<" .. word .. "\\>"
end

-- Combine an existing search register value with another (already escaped) term
-- using Vim's alternation: a -> a\|b
M.append = function(previous, term)
	return previous .. "\\|" .. term
end

M.append_word = function(previous, word)
	return previous .. "\\|" .. M.word_pattern(word)
end

-- Turn a (possibly multi-line, already escaped) selection into a single search
-- pattern. Leading whitespace on each line is collapsed to \s* so the match is
-- robust against re-indentation; a single line is returned verbatim.
M.multiline_pattern = function(text)
	local lines = {}
	for line in (text .. "\n"):gmatch("(.-)\n") do
		line = line:gsub("^%s*", "") -- trim leading whitespace only
		table.insert(lines, line)
	end

	-- Drop a spurious trailing empty line when the source had no trailing newline.
	if not text:match("\n$") and lines[#lines] == "" then
		table.remove(lines)
	end

	if #lines <= 1 then
		return lines[1] or ""
	end

	return "\\s*" .. table.concat(lines, "\\n\\s*")
end

return M
