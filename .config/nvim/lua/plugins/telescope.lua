-- nvim-telescope/telescope.nvim
-- gaze deeply into unknown regions using the power of the moon.
return {
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x',
    keys = {
      { '<leader>ff', mode = { 'n' },
        function()
          vim.cmd('Telescope find_files')
        end,
        desc = 'find files',
      },
      { '<leader>fg', mode = { 'n' },
        function()
          vim.cmd('Telescope live_grep')
        end,
        desc = 'live grep',
      },
      { '<leader>fb', mode = { 'n' },
        function()
          vim.cmd('Telescope buffers')
        end,
        desc = 'buffers',
      },
      { '<leader>fB', mode = { 'n' },
        function()
          vim.cmd('Telescope scope buffers')
        end,
        desc = 'buffers',
      },
      { '<leader>fh', mode = { 'n' },
        function()
          vim.cmd('Telescope help_tags')
        end,
        desc = 'help tags',
      },
      { '<leader>fc', mode = { 'n' },
        function()
          vim.cmd('Telescope grep_string')
        end,
        desc = 'current word',
      },
      { '<leader>fo', mode = { 'n' },
        function()
          vim.cmd('Telescope oldfiles')
        end,
        desc = 'recent files',
      },
      { '<leader>fs', mode = { 'n' },
        function()
          vim.cmd('Telescope spell_suggest')
        end,
        desc = 'spelling',
      },
      { '<leader>ld', mode = { 'n' },
        function()
          vim.cmd('Telescope diagnostics')
        end,
        desc = 'diagnostics',
      },
      { '<leader>fd', mode = { 'n' },
        function()
          vim.cmd('Telescope lsp_definitions')
        end,
        desc = 'definitions',
      },
      { '<leader>li', mode = { 'n' },
        function()
          vim.cmd('Telescope lsp_implementations')
        end,
        desc = 'implementations',
      },
      { '<leader>lt', mode = { 'n' },
        function()
          vim.cmd('Telescope lsp_type_definitions')
        end,
        desc = 'type definitions',
      },
      { '<leader>lr', mode = { 'n' },
        function()
          vim.cmd('Telescope lsp_references')
        end,
        desc = 'word references',
      },
    },
    opts = function()
      local opts = {}
      return opts
    end,
    config = function()
      require'telescope'.setup {
        defaults = {
          layout_strategy = 'vertical',
          layout_config = {
            height = 0.9,
            width = 0.9,
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          grep_string = {
            additional_args = {"--hidden"}
          },
          live_grep = {
            additional_args = {"--hidden"},
          },
        },
      }
      require'telescope'.load_extension('scope')
    end,
  },
}
