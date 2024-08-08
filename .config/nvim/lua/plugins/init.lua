return {
  { 'nvim-lua/plenary.nvim', lazy = false, },
  { 'nvim-tree/nvim-web-devicons',  lazy = false },
  -- { 'numToStr/Comment.nvim' },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },
  { 'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    event = "InsertEnter",
    dependencies = {
      'rafamadriz/friendly-snippets'
    },
  },
}
