-- monaqa/dial.nvim
-- extended increment/decrement plugin written in Lua
return {
  'monaqa/dial.nvim',
  keys = {
    { '<c-i>',
      function()
        require'dial.map'.manipulate('increment', 'normal')
      end,
      mode = { 'n' },
      desc = 'increment'
    },
    { '<c-x>',
      function()
        require'dial.map'.manipulate('decrement', 'normal')
      end,
      mode = { 'n' },
      desc = 'decrement'
    },
  },
  config = function()
    local augend = require'dial.augend'
    require'dial.config'.augends:register_group {
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.new {
          elements = {'True', 'False'},
          word = true, cyclic = true,
        },
        augend.constant.new {
          elements = {'FALSE', 'TRUE'},
          word = true, cyclic = true,
        },
        augend.constant.new {
          elements = {'true', 'false'},
          word = true, cyclic = true,
        },
        augend.constant.new {
          elements = {'or', 'and'},
          word = true, cyclic = true,
        },
        augend.constant.new {
          elements = {'or', 'and'},
          word = true, cyclic = true,
        },
        augend.constant.new {
          elements = {'==', '~='},
          word = false, cyclic = true,
        },
      },
    }
  end,
}
