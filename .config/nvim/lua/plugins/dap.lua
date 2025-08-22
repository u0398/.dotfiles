return {
  'mfussenegger/nvim-dap',
  lazy = false,
  dependencies = {
    'rcarriga/nvim-dap-ui',
    { 'jbyuki/one-small-step-for-vimkind',
      -- stylua: ignore
      config = function()
        local dap = require'dap'
        dap.adapters.nlua = function(callback)
          local adapter = {
            type = 'server',
            host = '127.0.0.1',
            port = 8086,
          }
          dap.run = function(c)
            adapter.port = c.port
            adapter.host = c.host
          end
          require'osv'.run_this()
          callback(adapter)
        end
        dap.adapters.codelldb = {
          type = 'server',
          port = "${port}",
          executable = {
            command = os.getenv('HOME') .. '/.local/share/nvim/mason/packages/codelldb/codelldb',
            args = {"--port", "${port}"},

            -- On windows you may have to uncomment this:
            -- detached = false,
          }
        }
        dap.configurations.lua = {
          {
            type = 'nlua',
            request = 'attach',
            name = 'Run this file',
            start_neovim = {},
          },
          {
            type = 'nlua',
            request = 'attach',
            name = 'Attach to running Neovim instance (port = 8086)',
            port = 8086,
          },
        }
        dap.configurations.cpp = {
          {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
          },
        }
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp
      end,
    },
    { 'rust-lang/rust.vim',
      ft = 'rust',
      init = function ()
        vim.g.rustfmt_autosave = 1
      end
    },
    { 'Saecki/crates.nvim',
      event = { 'BufRead Cargo.toml' }
      --opts = {
      --  completion = {
      --    cmp = { enabled = true },
      --  },
      --},
    },
    { 'theHamsta/nvim-dap-virtual-text',
      opts = {},
    },
  },
  keys = {
    { '<leader>d', '', desc = '+debug', mode = {'n', 'v'} },
    { '<leader>dB', function() require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Breakpoint Condition' },
    { '<leader>db', function() require'dap'.toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
    { '<leader>dc', function() require'dap'.continue() end, desc = 'Continue' },
    { '<leader>da', function() require'dap'.continue({ before = get_args }) end, desc = 'Run with Args' },
    { '<leader>dC', function() require'dap'.run_to_cursor() end, desc = 'Run to Cursor' },
    { '<leader>dg', function() require'dap'.goto_() end, desc = 'Go to Line (No Execute)' },
    { '<leader>di', function() require'dap'.step_into() end, desc = 'Step Into' },
    { '<leader>dj', function() require'dap'.down() end, desc = 'Down' },
    { '<leader>dk', function() require'dap'.up() end, desc = 'Up' },
    { '<leader>dl', function() require'dap'.run_last() end, desc = 'Run Last' },
    { '<leader>do', function() require'dap'.step_out() end, desc = 'Step Out' },
    { '<leader>dO', function() require'dap'.step_over() end, desc = 'Step Over' },
    { '<leader>dp', function() require'dap'.pause() end, desc = 'Pause' },
    { '<leader>dr', function() require'dap'.repl.toggle() end, desc = 'Toggle REPL' },
    { '<leader>ds', function() require'dap'.session() end, desc = 'Session' },
    { '<leader>dt', function() require'dap'.terminate() end, desc = 'Terminate' },
    { '<leader>dw', function() require'dap.ui.widgets'.hover() end, desc = 'Widgets' },
  },
  config = function()
    -- setup dap config by VsCode launch.json file
    local vscode = require'dap.ext.vscode'
    local json = require'plenary.json'
    vscode.json_decode = function(str)
      return vim.json.decode(json.json_strip_comments(str))
    end

    -- Extends dap.configurations with entries read from .vscode/launch.json
    if vim.fn.filereadable('.vscode/launch.json') then
      vscode.load_launchjs()
    end
  end,
}
