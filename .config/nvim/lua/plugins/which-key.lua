-- folke/which-key.nvim 
-- helps you remember your Neovim keymaps, showing keybindings in a popup
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  -- opts_extend = { 'spec' },
  opts = {
    defaults = {},
    spec = {
      {
        { '<leader>f', group = 'file/find' },
        { '<leader>l', group = 'lsp' },
        { '<leader><tab>', group = 'tabs' },
        { '<leader>fs', group = 'sessions' },
      },
    },
    delay = 1000,
    keys = {
      scroll_down = "<a-d>", -- binding to scroll down inside the popup
      scroll_up = "<a-u>", -- binding to scroll up inside the popup
    },
  },
  keys = {
    { '<leader><space>',
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
  end
}
