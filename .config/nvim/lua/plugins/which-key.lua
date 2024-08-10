-- folke/which-key.nvim 
-- helps you remember your Neovim keymaps, showing keybindings in a popup
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    defaults = {},
    spec = {
      {
        { '<leader>f',     group = 'Find' },
        { '<leader>l',     group = 'LSP' },
        { '<leader><tab>', group = 'Tabs' },
        { '<leader>s',     group = 'Sessions' },
        { '<leader>r',     group = 'Registers' },
      },
    },
    delay = 1000,
    keys = {
      scroll_down = '<a-d>', -- binding to scroll down inside the popup
      scroll_up =   '<a-u>', -- binding to scroll up inside the popup
    },
  },
  keys = {
    { '<leader><space>',
      function()
        require'which-key'.show({ global = false })
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
  end
}
