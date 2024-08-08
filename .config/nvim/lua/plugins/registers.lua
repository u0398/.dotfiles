-- tversteeg/registers.nvim
-- show register content when you try to access it in Neovim
return {
  'tversteeg/registers.nvim',
    name = "registers",
    cmd = 'Registers',
    keys = {
      { '"',     mode = { 'n', 'v' } },
      { '<C-R>', mode = 'i' }
    },
    config = function()
      require'registers'.setup {
        window = {
          border = 'rounded',
          transparency = 0,
        }
      }
    end,
}
