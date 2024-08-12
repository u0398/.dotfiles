require'config'

require('lazy').setup {
  spec = {
    { 'nvim-lua/plenary.nvim', lazy = false, },
    { 'nvim-tree/nvim-web-devicons',  lazy = false },
    { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },
    { 'RRethy/vim-illuminate', event = 'InsertEnter' },
    { 'folke/noice.nvim',
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
            timeout = 4000,
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
    },
    { import = 'plugins.auto-session' },
    { import = 'plugins.catppuccin' },
    { import = 'plugins.cmp' },
    { import = 'plugins.dashboard' },
    { import = 'plugins.dial' },
    -- { import = 'plugins.fidget' },
    -- { import = 'plugins.fzf' },
    { import = 'plugins.gitsigns' },
    { import = 'plugins.heirline' },
    { import = 'plugins.hop' },
    { import = 'plugins.indent-blankline' },
    { import = 'plugins.lspconfig' },
    { import = 'plugins.luasnip' },
    { import = 'plugins.mason' },
    { import = 'plugins.neo-tree' },
    { import = 'plugins.neoscroll' },
    { import = 'plugins.impairative' },
    -- { import = 'plugins.nvim-tree' },
    { import = 'plugins.registers' },
    -- { import = 'plugins.startuptime' },
    { import = 'plugins.statuscol' },
    { import = 'plugins.surround' },
    { import = 'plugins.telescope' },
    { import = 'plugins.treesitter-textobjects' },
    { import = 'plugins.treesitter' },
    { import = 'plugins.ufo' },
    { import = 'plugins.virt-column' },
    { import = 'plugins.which-key' },
    { import = 'plugins.yanky' },
  },
  checker = { enabled = true },
  defaults = {
    lazy = true,
    version = false,
  },
}
