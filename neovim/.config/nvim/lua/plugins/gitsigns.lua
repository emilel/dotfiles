-- Fill the quickfix with gitsigns' own hunks (repo-wide, same definition as the
-- gutter signs and <c-g><c-s>), then browse them in telescope. Fuzzy-filter to
-- the files you care about and <c-q> to send just those back to the quickfix;
-- then <c-j>/<c-k> iterate the curated list. telescope is require()d here so it
-- stays lazy instead of loading with gitsigns at file-open.
-- New files need both halves: attach_to_untracked pulls in `??` files, and
-- lib.githunks pulls in the `git add -N` ones gitsigns' own scan skips.
local hunks_to_qf = function()
	require("gitsigns").setqflist("all", { open = false }, function()
		vim.fn.setqflist(require("lib.githunks").qf_items(), "a")
		require("telescope.builtin").quickfix({ prompt_title = "Git Hunks" })
	end)
end

return {
	"lewis6991/gitsigns.nvim",
	keys = {
		{
			"<c-g><c-s>",
			function()
				require("gitsigns").stage_hunk()
			end,
			desc = "Stage hunk",
		},
		{
			"<c-g><c-s>",
			function()
				require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
			mode = "x",
			desc = "Stage hunk",
		},
		{
			"<c-g><c-u>",
			function()
				require("gitsigns").undo_stage_hunk()
			end,
			desc = "Undo hunk",
		},
		{
			"<c-g><c-x>",
			function()
				require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
			desc = "Reset hunk",
		},
		{
			"<c-g><c-x>",
			function()
				require("gitsigns").reset_hunk()
			end,
			mode = "x",
			desc = "Reset hunk",
		},
		{
			"<c-g><c-p>",
			function()
				require("gitsigns").preview_hunk()
			end,
			desc = "Preview hunk",
		},
		{
			"<c-g><c-t>",
			function()
				require("gitsigns").toggle_deleted()
			end,
			desc = "Toggle deleted",
		},
		{
			"<c-g><c-h>",
			hunks_to_qf,
			desc = "Hunks to quickfix",
		},
		{
			"<c-g><c-m>",
			"<cmd>silent !git checkout master -- %<cr>",
			desc = "Revert to master",
		},
		{
			"]h",
			function()
				require("gitsigns").nav_hunk("next")
			end,
			desc = "Next hunk",
		},
		{
			"[h",
			function()
				require("gitsigns").nav_hunk("prev")
			end,
			desc = "Previous hunk",
		},
		{
			"ah",
			function()
				require("gitsigns").select_hunk()
			end,
			mode = { "o", "x" },
			desc = "Git hunk (around)",
		},
	},
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		sign_priority = 11,
		-- Off by default upstream: without it a brand-new file has no signs, no
		-- ]h/[h, and never shows up in <c-g><c-h>.
		attach_to_untracked = true,
	},
}
