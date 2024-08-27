return {
  'Robitx/gp.nvim',
  keys = {
    {
      '<c-s>n',
      '<cmd>GpChatNew popup<cr>',
      desc = 'Start new AI chat'
    },
    {
      '<c-s><space>',
      ':GpChatPaste popup<cr>',
      mode = 'x',
      desc = 'Paste to AI chat',
    },
    {
      '<c-s>r',
      '<cmd>GpRewrite<cr>',
      mode = 'x',
      desc = 'Rewrite selected text with AI'
    },
    {
      '<c-s><space>',
      '<cmd>GpChatToggle popup<cr>',
      desc = 'Toggle AI chat'
    }
  },
  config = function()
    require('gp').setup({
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1/chat/completions",
          secret = os.getenv("OPENAI_API_KEY"),
        },
      },
      chat_shortcut_respond = { modes = { "n" }, shortcut = "<cr><cr>" },
      chat_user_prefix = "## User",
      chat_assistant_prefix = { "## ", "{{agent}}" },
      chat_conceal_model_params = false,
      chat_template = require("gp.defaults").short_chat_template,
      chat_free_cursor = true,
    })
  end
}
