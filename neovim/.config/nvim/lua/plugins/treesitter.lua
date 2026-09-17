-- nvim-treesitter's `main` branch, which is a different plugin from the
-- archived `master`: it installs parsers and ships queries, and that is all.
-- Every *feature* master used to switch on -- highlighting, folds, injections,
-- incremental selection -- is Neovim's own now, so the config below is one
-- FileType autocmd turning them on per buffer rather than a `configs.setup`.
--
-- Indentation is the one feature still owned by the plugin, and still marked
-- experimental. Parsers are built with the `tree-sitter` CLI (bootstrap.sh
-- installs it); a missing CLI shows up as a failed :TSInstall, and `:checkhealth
-- nvim-treesitter` names it.

-- Parsers to keep installed: what this config actually edits. Kept explicit --
-- `main` installs nothing on its own, and a parser that arrives by surprise is
-- a compile nobody asked for.
local parsers = {
	"bash", -- also zsh/sh, see core/filetypes.lua
	"c",
	"diff",
	"git_config",
	"gitcommit",
	"json", -- and jsonc, which Neovim maps onto the same parser
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline", -- the fences' own contents
	"python",
	"query", -- .scm, i.e. treesitter's own queries
	"regex",
	"sql",
	"toml",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

-- Treesitter indent is worse than the built-in here, so these buffers keep
-- `indentexpr` as they find it. python: disabled on master too. markdown: the
-- query marks list items @indent.auto, which copies the bullet's own indent, so
-- a wrapped or <CR>'d list line lost the hang that `fo+=n` gives it for free.
local plain_indent = { python = true, markdown = true }

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- `main` does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup()
			require("nvim-treesitter").install(parsers) -- async, and a no-op once installed

			vim.api.nvim_create_autocmd("FileType", {
				desc = "treesitter highlighting and indent, where there's a parser",
				callback = function(args)
					local filetype = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(filetype)
					-- No parser installed for this filetype: leave the buffer on
					-- regexp highlighting rather than erroring on every :e.
					if not lang or not pcall(vim.treesitter.start, args.buf, lang) then
						return
					end
					if not plain_indent[filetype] then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = {
			-- Same keys master's `textobjects.select` block bound; `main` has no
			-- module system, so each one is a plain keymap onto the same query.
			{ "a,", desc = "a parameter", mode = { "x", "o" } },
			{ "i,", desc = "inner parameter", mode = { "x", "o" } },
			{ "ac", desc = "a call", mode = { "x", "o" } },
			{ "ic", desc = "inner call", mode = { "x", "o" } },
			{ "af", desc = "a function", mode = { "x", "o" } },
			{ "if", desc = "inner function", mode = { "x", "o" } },
			{ "al", desc = "a class", mode = { "x", "o" } },
			{ "il", desc = "inner class", mode = { "x", "o" } },
			{ ">,", desc = "swap parameter next" },
			{ "<,", desc = "swap parameter previous" },
		},
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
			})

			local select = require("nvim-treesitter-textobjects.select")
			local textobjects = {
				["a,"] = "@parameter.outer",
				["i,"] = "@parameter.inner",
				["ac"] = "@call.outer",
				["ic"] = "@call.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["al"] = "@class.outer",
				["il"] = "@class.inner",
			}
			for key, query in pairs(textobjects) do
				vim.keymap.set({ "x", "o" }, key, function()
					select.select_textobject(query, "textobjects")
				end, { desc = query })
			end

			-- Both directions on `.inner`, where master used `.outer` for one of
			-- them: an outer parameter range swallows its separating comma, so
			-- consecutive ones overlap and `main`'s "starts after this one ends"
			-- search never finds the neighbour. `.outer` silently does nothing.
			local swap = require("nvim-treesitter-textobjects.swap")
			vim.keymap.set("n", ">,", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Swap parameter with the next" })
			vim.keymap.set("n", "<,", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "Swap parameter with the previous" })
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").disable()
			vim.keymap.set("n", "\\c", function()
				require("treesitter-context").toggle()
			end, { desc = "toggle treesitter context" })
		end,
	},
}
