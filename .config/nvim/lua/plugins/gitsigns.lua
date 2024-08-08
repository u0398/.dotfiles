-- lewis6991/gitsigns.nvim
-- git decorations implemented purely in Lua
return {
  { 'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
      require('gitsigns').setup()
    end,
  },

}

