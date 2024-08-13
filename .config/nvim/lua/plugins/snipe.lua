return {
  'leath-dub/snipe.nvim',
  keys = {
    { '<leader>fb', function () require'snipe'.open_buffer_menu() end, desc = 'Snipe a buffer!' }
  },
  opts = {
    ui = {
      max_width = -1,
      position = 'topleft',
    },
    navigate = {
      next_page = 'J',
      prev_page = 'K',
      under_cursor = '<cr>',
      cancel_snipe = '<esc>',
    },
    hints = {
      dictionary = 'asghlqwertyuiopzxcvbnmfj'
    }
  }
}
