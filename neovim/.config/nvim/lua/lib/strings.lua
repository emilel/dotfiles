-- Pure-ish string helpers used across keymaps.
-- Kept free of editor state so they can be unit-tested in isolation.
local M = {}

-- Escape a string so it can be used literally inside a Vim regex / :substitute.
M.escape_vim = function(string)
	return vim.fn.escape(string, "\\.^$*[]/")
end

-- Escape a string so it can be used literally inside a PCRE pattern (ripgrep).
M.escape_pcre = function(string)
	local pcre_specials = "([%.%^%$%*%+%?%(%)%[%]%{%}%|%\\%-])"
	return string:gsub(pcre_specials, "\\%1")
end

return M
