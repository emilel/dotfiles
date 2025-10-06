return {
	"luukvbaal/nnn.nvim",
	opts = {},
	keys = {
		{
			"_",
			"<cmd>NnnPicker<cr>",
			desc = "Pick file",
		},
		{
			"-",
			"<cmd>NnnPicker %:p:h<cr>",
			desc = "Open file's directory",
		},
	},
}
