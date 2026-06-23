-- Filetype detection overrides (formerly settings/filetypes.lua).
local detect = {
	{ pattern = { "*.topo", "*.config" }, filetype = "xml" },
	{ pattern = "*.h", filetype = "c" },
	{ pattern = "*.inc", filetype = "c" },
	{ pattern = "*/.config/waybar/config", filetype = "jsonc" },
	{ pattern = { "*.zsh", "*.sh" }, filetype = "bash" },
}

for _, rule in ipairs(detect) do
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = rule.pattern,
		command = "set filetype=" .. rule.filetype,
	})
end
