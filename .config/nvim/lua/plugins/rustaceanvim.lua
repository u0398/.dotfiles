return {
  'mrcjkb/rustaceanvim',
  version = '^5',
  ft = { 'rust' },
  lazy = false,
  opts = {
    server = {
      on_attach = function(_, bufnr)
        vim.keymap.set('n', '<leader>cR', function()
          vim.cmd.RustLsp('codeAction')
        end, { desc = 'Code Action', buffer = bufnr })
        vim.keymap.set('n', '<leader>dr', function()
          vim.cmd.RustLsp('debuggables')
        end, { desc = 'Rust Debuggables', buffer = bufnr })
      end,
      default_settings = {
        -- rust-analyzer language server configuration
        ['rust-analyzer'] = {
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
              ['async-trait'] = { 'async_trait' },
              ['napi-derive'] = { 'napi' },
              ['async-recursion'] = { 'async_recursion' },
            },
          },
        },
      },
    },
    dap = {
      adapter = function()
        local mason_registry = require'mason-registry'
        local codelldb = mason_registry.get_package'codelldb'
        local extension_path = codelldb:get_install_path() .. '/extension'
        local codelldb_path = extension_path .. 'adapter/codelldb'
        local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
        local cfg = require'rustaceanvim.config'

        return cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
      end,
    },
  },
  config = function(_, opts)
    vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
  end,
}
