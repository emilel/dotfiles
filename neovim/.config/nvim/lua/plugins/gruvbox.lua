return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		vim.cmd([[ colorscheme gruvbox ]])
		-- Folded headings: underline instead of italic (keep gruvbox's colors).
		local folded = vim.api.nvim_get_hl(0, { name = "Folded" })
		folded.italic = false
		folded.underline = true
		vim.api.nvim_set_hl(0, "Folded", folded)
	end,
}
