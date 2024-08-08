-- lukas-reineke/virt-column.nvim
-- display a character as the colorcolumn
return {
  'lukas-reineke/virt-column.nvim',
  lazy = false,
  opts = {},
  config = function()
    require'virt-column'.setup {
      char = '▏',
      highlight = 'VirtColumn',
    }
  end
}
