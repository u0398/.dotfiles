-- folke/which-key.nvim 
-- helps you remember your Neovim keymaps, showing keybindings in a popup
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    defaults = {},
    spec = {
      {
        { '<leader>b',     group = 'Buffers' },
        { '<leader>f',     group = 'Find' },
        { '<leader>fb',     icon = { icon = '󱒄', color = 'red' } },
        { '<leader>l',     group = 'LSP', icon = { icon = '󱚊', color = 'cyan' } },
        { '<leader><tab>', group = 'Tabs' },
        { '<leader>s',     group = 'Sessions' },
        { '<leader>r',     group = 'Registers', icon = { icon = '', color = 'orange' } }
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
