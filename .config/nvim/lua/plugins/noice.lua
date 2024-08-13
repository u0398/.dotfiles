return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    presets = {
      command_palette = true,
      long_message_to_split = false,
      inc_rename = false,
      lsp_doc_border = false,
    },
    views = {
      mini = {
        timeout = 3500,
        position = {
          row = -2,
          col = -1,
        },
        win_options = {
          winblend = 0,
        }
      },
    },
    lsp = {
      progress = {
        view = 'mini',
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
  }
}
