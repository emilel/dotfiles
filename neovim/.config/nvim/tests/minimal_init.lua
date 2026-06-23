-- Minimal init for the test suite. Loads ONLY this config's lua modules plus
-- plenary (the test runner) -- no plugins, no lazy. The behavior specs exercise
-- the global keymaps, which deliberately have no plugin dependencies.
local script = debug.getinfo(1, "S").source:sub(2)
local tests_dir = vim.fn.fnamemodify(script, ":p:h")
local config_dir = vim.fn.fnamemodify(tests_dir, ":h")

vim.opt.runtimepath:prepend(config_dir)

-- Disable swap files: headless tests create many unnamed buffers and the swap
-- file collisions between tests cause E300/E303 errors that abort test cases.
vim.opt.swapfile = false

-- Locate plenary: explicit override, the lazy install, or a local clone.
local plenary = os.getenv("PLENARY_PATH")
if not plenary or vim.fn.isdirectory(plenary) == 0 then
	local candidates = {
		vim.fn.stdpath("data") .. "/lazy/plenary.nvim",
		tests_dir .. "/.deps/plenary.nvim",
	}
	for _, c in ipairs(candidates) do
		if vim.fn.isdirectory(c) == 1 then
			plenary = c
			break
		end
	end
end
if plenary and vim.fn.isdirectory(plenary) == 1 then
	vim.opt.runtimepath:prepend(plenary)
end

-- Load the global keymaps so the behavior specs can drive them.
require("keymaps")
