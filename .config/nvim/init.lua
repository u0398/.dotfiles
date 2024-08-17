require'config'

require('lazy').setup {
  spec = {
    { 'nvim-lua/plenary.nvim', lazy = false, },
    { 'nvim-tree/nvim-web-devicons',  lazy = false },
    { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },
    { 'RRethy/vim-illuminate', event = 'InsertEnter' },
    {
      'mrcjkb/rustaceanvim',
      version = '^5',
      ft = { "rust" },
      lazy = false,
      opts = {
    server = {
      on_attach = function(_, bufnr)
        vim.keymap.set("n", "<leader>cR", function()
          vim.cmd.RustLsp("codeAction")
        end, { desc = "Code Action", buffer = bufnr })
        vim.keymap.set("n", "<leader>dr", function()
          vim.cmd.RustLsp("debuggables")
        end, { desc = "Rust Debuggables", buffer = bufnr })
      end,
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          -- Add clippy lints for Rust.
          checkOnSave = true,
          procMacro = {
            enable = true,
            ignored = {
              ["async-trait"] = { "async_trait" },
              ["napi-derive"] = { "napi" },
              ["async-recursion"] = { "async_recursion" },
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
  end,
    },
    { 'mfussenegger/nvim-dap',
      lazy = false,
      dependencies = {
        "rcarriga/nvim-dap-ui",
        {
      "jbyuki/one-small-step-for-vimkind",
      -- stylua: ignore
      config = function()
        local dap = require("dap")
        dap.adapters.nlua = function(callback)
          local adapter = {
            type = "server",
            host = "127.0.0.1",
            port = 8086,
          }
            dap.run = function(c)
              adapter.port = c.port
              adapter.host = c.host
            end
            require("osv").run_this()
          callback(adapter)
        end
        dap.configurations.lua = {
          {
            type = "nlua",
            request = "attach",
            name = "Run this file",
            start_neovim = {},
          },
          {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance (port = 8086)",
            port = 8086,
          },
        }
      end,
    },
        {
  "Saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  opts = {
    completion = {
      cmp = { enabled = true },
    },
  },
},
        -- virtual text for the debugger
        {
          "theHamsta/nvim-dap-virtual-text",
          opts = {},
        },
      },
      keys = {
        { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
        { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
        { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
        { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
        { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
        { "<leader>dj", function() require("dap").down() end, desc = "Down" },
        { "<leader>dk", function() require("dap").up() end, desc = "Up" },
        { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
        { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
        { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
        { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
        { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
        { "<leader>ds", function() require("dap").session() end, desc = "Session" },
        { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      },
      config = function()
        -- setup dap config by VsCode launch.json file
        local vscode = require("dap.ext.vscode")
        local json = require("plenary.json")
        vscode.json_decode = function(str)
          return vim.json.decode(json.json_strip_comments(str))
        end

        -- Extends dap.configurations with entries read from .vscode/launch.json
        if vim.fn.filereadable(".vscode/launch.json") then
          vscode.load_launchjs()
        end
      end,
    },
    {
  "rcarriga/nvim-dap-ui",
  dependencies = { "nvim-neotest/nvim-nio" },
  -- stylua: ignore
  keys = {
    { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
  },
  opts = {},
  config = function(_, opts)
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup(opts)
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({})
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close({})
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close({})
    end
  end,
},
    {
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = "mason.nvim",
  cmd = { "DapInstall", "DapUninstall" },
  opts = {
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_installation = true,

    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    handlers = {},

    -- You'll need to check that you have the required things installed
    -- online, please don't ask me how to install them :)
    ensure_installed = {
      -- Update this to ensure that you have the debuggers for the langs you want
    },
  },
  -- mason-nvim-dap is loaded when nvim-dap loads
  config = function() end,
},
    { 'nvim-neotest/nvim-nio' },
    {
      'julianolf/nvim-dap-lldb',
      dependencies = { 'mfussenegger/nvim-dap' },
      -- opts = { codelldb_path = "/path/to/codelldb" },
    },
    {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { "vim%.uv" } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
    { import = 'plugins.auto-session' },
    { import = 'plugins.catppuccin' },
    { import = 'plugins.cmp' },
    { import = 'plugins.dashboard' },
    { import = 'plugins.dial' },
    -- { import = 'plugins.fidget' },
    -- { import = 'plugins.f' }
    { import = 'plugins.gitsigns' },
    { import = 'plugins.heirline' },
    { import = 'plugins.hop' },
    { import = 'plugins.indent-blankline' },
    { import = 'plugins.lspconfig' },
    { import = 'plugins.luasnip' },
    { import = 'plugins.mason' },
    { import = 'plugins.neo-tree' },
    { import = 'plugins.neoscroll' },
    { import = 'plugins.noice' },
    { import = 'plugins.impairative' },
    -- { import = 'plugins.nvim-tree' },
    { import = 'plugins.registers' },
    -- { import = 'plugins.startuptime' },
    { import = 'plugins.snipe' },
    { import = 'plugins.statuscol' },
    { import = 'plugins.surround' },
    { import = 'plugins.telescope' },
    { import = 'plugins.treesitter-textobjects' },
    { import = 'plugins.treesitter' },
    { import = 'plugins.ufo' },
    { import = 'plugins.virt-column' },
    { import = 'plugins.which-key' },
    { import = 'plugins.yanky' },
  },
  checker = { enabled = true },
  defaults = {
    lazy = true,
    version = false,
  },
}
