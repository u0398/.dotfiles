-- kylechui/nvim-surround
-- surround selections, stylishly
return{
  'kylechui/nvim-surround',
  version = '*',
  event = 'VeryLazy',
  config =
    function()
      require('nvim-surround').setup()
    end
}

