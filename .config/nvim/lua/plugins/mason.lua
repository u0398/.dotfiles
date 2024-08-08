-- williamboman/mason.nvim
-- easily install and manage LSP servers, DAP servers, linters, and formatters.
return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
  },
  event = "filetype",
  config = function()
    require'mason'.setup {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    }
  end
}
