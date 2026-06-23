-- Pure builders for the :substitute command lines used by the replace keymaps.
-- These are fed to the command line WITHOUT a trailing <cr>: the user reviews /
-- edits the replacement, then presses <cr>. The cursor is positioned by feeding
-- N <left> presses, where N is the length of the trailing literal below -- this
-- replaces the old hard-coded "<left> times 22" magic number with something
-- derived (and testable).
local M = {}

-- Flags for the range substitute (<space>r / <space>R): confirm each match.
M.range_flags = "/gc"

-- Trailing boilerplate for the current-line substitute (visual R): apply, clear
-- search highlight, restore cursor to mark u.
M.line_suffix = "/g | :noh | :normal `u"

-- :.,$s/<pattern>/<replacement>/gc -- substitute from current line to EOF.
M.range_substitute = function(pattern, replacement)
	return ":.,$s/" .. pattern .. "/" .. replacement .. M.range_flags
end

-- Number of <left> presses to land the cursor at the end of the replacement.
M.range_lefts = function()
	return #M.range_flags
end

-- mu:s/<expr>/<expr>/g | :noh | :normal `u -- current-line substitute. <expr> is
-- a command-line snippet (e.g. an expression register) inserted verbatim.
M.line_substitute = function(expr)
	return "mu:s/" .. expr .. "/" .. expr .. M.line_suffix
end

M.line_lefts = function()
	return #M.line_suffix
end

return M
