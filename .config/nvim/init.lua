require'config'

require('lazy').setup {
  spec = {
    { import = 'plugins' },
  },
  checker = { enabled = true },
  defaults = {
    lazy = true,
    version = false,
  },
}
