return {
	'Konfekt/vim-CtrlXA',
    lazy = true,
    keys = {
        {'<c-a>' },
        {'<c-x>' }
    },
	config = function()
		vim.g.CtrlXA_move = 1
	end,
}
