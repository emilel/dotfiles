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
		{
			"<space>g",
			function()
				require("lib.pickers").directory_then_nnn()
			end,
			desc = "Pick directory (Telescope) and open nnn",
		},
	},
}
