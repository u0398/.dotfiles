-- smoka7/hop.nvim
-- an EasyMotion-like plugin allowing you to jump anywhere in a document
return {
  { 'smoka7/hop.nvim',
    version = 'v2.*',
    keys = {
      { 'f',
        function()
          local directions = require'hop.hint'.HintDirection
          require'hop'.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
        end, { remap = true },
        desc = ''
      },
      { 'F',
        function()
          local directions = require'hop.hint'.HintDirection
          require'hop'.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
        end, { remap = true },
        desc = ''
      },
      { 't',
        function()
          local directions = require'hop.hint'.HintDirection
          require'hop'.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
        end, { remap = true }, desc = ''
      },
      { 'T',
        function()
          local directions = require'hop.hint'.HintDirection
          require'hop'.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
        end, { remap = true },
        desc = ''
      },
      { '<leader>j',
        function()
          require'hop'.hint_char1({ multi_windows = true })
        end,
        desc = 'Hop (anywhere)'
      },
      { '<leader>y',
        function()
          require'hop-yank'.yank_char1({ multi_windows = true })
        end,
        desc = 'Hop (anywhere)'
      },
      { '<leader>J',
        function()
          require'hop'.hint_patterns({ multi_windows = true, yank_register = '*' })
        end,
        desc = 'Hop (search /)'
      },
      { '<leader>h',
        function()
          require'hop'.hint_lines_skip_whitespace({ multi_windows = true })
        end,
        desc = 'Hop (to first char)'
      },
      { '<leader>H',
        function()
          require'hop'.hint_lines({ multi_windows = true })
        end,
        desc = 'Hop (to line start)'
      },
    },
    opts = {
      quit_key = '<Esc>',
    },
    config = function(opts)
      require'hop'.setup(opts)
    end,
  },
}
