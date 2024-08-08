-- luukvbaal/statuscol.nvim
-- status column plugin that provides a configurable 'statuscolumn' and click handlers
return {
  'luukvbaal/statuscol.nvim',
  -- event = 'VeryLazy',
  lazy = false,
  config = function()
    local builtin = require'statuscol.builtin'
    require'statuscol'.setup {
      setopt = true,
      thousands = false,
      relculright = true,
      segments = {
        { text = { builtin.foldfunc }, colwidth = 1, click = "v:lua.ScFa" },
        {
          sign = { namespace = { "diagnostic/signs" }, maxwidth = 1, foldclosed = false, auto = true },
          click = "v:lua.ScSa",
        },
        { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
        {
          sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false, wrap = true },
            click = "v:lua.ScSa"
        },
      }
    }
  end
}
