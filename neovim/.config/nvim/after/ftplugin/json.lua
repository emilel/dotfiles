vim.opt_local.formatprg = "jq ."

-- <CR> folds the object or array under the cursor. Its fold query also folds a
-- multiline `pair` -- `"key": {` opens both the pair and the value's fold on
-- that line -- which is the case lib.folds closes all the way out for.
vim.keymap.set("n", "<cr>", require("lib.folds").toggle, { buffer = true, desc = "Toggle fold" })
