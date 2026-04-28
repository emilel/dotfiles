vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = {
  ["markdown"] = false,
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	callback = function()
		pcall(vim.keymap.del, "i", "<Right>", { buffer = true })
		vim.keymap.set(
			"i",
			"<Right>",
			'copilot#Accept("\\<CR>")',
			{ expr = true, replace_keycodes = false, buffer = true, desc = "Copilot Accept" }
		)
	end,
})

return {
	"github/copilot.vim",
	lazy = false,
	keys = {
		{
			"<right>",
			'copilot#Accept("\\<cr>")',
			mode = "i",
			expr = true,
			replace_keycodes = false,
			desc = "Accept suggestion",
		},
		{
			"<tab>",
			'copilot#Accept("\\<cr>")',
			mode = "i",
			expr = true,
			replace_keycodes = false,
			desc = "Accept suggestion",
		},
		{
			"<c-l>",
			"<Plug>(copilot-accept-word)",
			mode = "i",
			desc = "Accept suggestion",
		},
		{ "<c-right>", "<Plug>(copilot-accept-word)", mode = "i", desc = "Accept suggested word" },
		{ "<c-down>", "<Plug>(copilot-next)", mode = "i", desc = "Cycle suggestion down" },
		{ "<c-up>", "<Plug>(copilot-previous)", mode = "i", desc = "Cycle suggestion up" },
	},
}
