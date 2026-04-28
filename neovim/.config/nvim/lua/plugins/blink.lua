return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets"
	},
	version = "1.*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "none",
			["<c-j>"] = { "show", "select_next", "fallback" },
			["<c-k>"] = { "select_prev", "fallback" },
			["<c-l>"] = { "accept", "snippet_forward", "fallback" },
			["<c-h>"] = { "snippet_backward", "fallback" },
			["<c-d>"] = { "show_documentation", "hide_documentation", "fallback" },
			["<c-s>"] = { "show_signature", "hide_signature", "fallback" },
		},
		signature = { enabled = false, window = { show_documentation = false } },
		enabled = function()
			return not vim.tbl_contains({ "markdown", "gitcommit" }, vim.bo.filetype)
		end,
		appearance = {
			nerd_font_variant = "mono",
			kind_icons = {
				Text = "Te",
				Method = "Me",
				Function = "Fu",
				Constructor = "Co",
				Field = "Fd",
				Variable = "Vr",
				Property = "Pr",
				Class = "Cl",
				Interface = "In",
				Struct = "St",
				Module = "Mo",
				Unit = "Un",
				Value = "Va",
				Enum = "En",
				EnumMember = "Em",
				Keyword = "Ke",
				Constant = "Cs",
				Snippet = "Sn",
				Color = "Co",
				File = "Fi",
				Reference = "Re",
				Folder = "Di",
				Event = "Ev",
				Operator = "Op",
				TypeParameter = "Tp",
			},
		},
		completion = {
			documentation = { auto_show = false },
			menu = {
				auto_show = false,
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "lua" },
	},
	opts_extend = { "sources.default" },
}
