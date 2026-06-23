-- Non-plugin runtime configuration, loaded in a deterministic order.
require("core.options")
require("core.autocmds")
require("core.filetypes")
require("core.commands")

-- Export the project's virtualenv before any LSP/linter/formatter starts.
require("lib.venv").activate()
