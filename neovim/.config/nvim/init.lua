local utils = require('utils')

require('config.lazy')
require('commands')

utils.require_directory('keymaps')
utils.require_directory('settings')

-- require('my_highlighter.init')
require('hl_marks.init')
