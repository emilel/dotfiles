if os.getenv("OPENAI_API_KEY") == nil then
	return {}
end

return {
	"jackMort/ChatGPT.nvim",
	keys = {
		{ ',ai', '<cmd>ChatGPT<cr>',                     desc = 'Run ChatGPT' },
		{ ',aI', '<cmd>ChatGPTEditWithInstructions<cr>', desc = 'Push code to ChatGPT' }
	},
	event = "VeryLazy",
	config = function()
		require("chatgpt").setup({
			chat_layout = {
				relative = "editor",
				position = "50%",
				size = {
					height = "75%",
					width = "75%",
				},
			},
			keymaps = {
				submit = '<c-space>'
			},
			yank_register = '+'
		})
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim"
	}
}
