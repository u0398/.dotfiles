-- smoka7/hop.nvim {{{2
-- an EasyMotion-like plugin allowing you to jump anywhere in a document
return {
  { 'smoka7/hop.nvim',
    version = 'v2.*',
    keys = {
      { '<leader>j',
        function()
          require'hop'.hint_char1()
        end,
        desc = 'Hop'
      },
      { '<leader>J',
        function()
          require'hop'.hint_char1({ current_line_only = true })
        end,
        desc = 'Hop (current line)'
      },
      { '<leader>h',
        function()
          require'hop'.hint_lines_skip_whitespace({ multi_windows = true })
        end,
        desc = 'Hop (first char)'
      },
      { '<leader>H',
        function()
          require'hop'.hint_lines({ multi_windows = true })
        end,
        desc = 'Hop (line start)'
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
