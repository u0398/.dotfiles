-- neovim/nvim-lspconfig
-- configs for the nvim LSP client
return {
  'neovim/nvim-lspconfig',
  lazy = false,
  dependencies = {
    'williamboman/mason.nvim',
  },
  opts = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function()
        local bufmap = function(mode, lhs, rhs)
          local opts = {buffer = true}
          vim.keymap.set(mode, lhs, rhs, opts)
        end
        -- Displays hover information about the symbol under the cursor
        bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
        -- Jump to the definition
        bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
        -- Jump to declaration
        bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
        -- Lists all the implementations for the symbol under the cursor
        bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
        -- Jumps to the definition of the type symbol
        bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
        -- Lists all the references 
        bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
        -- Displays a function's signature information
        bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
        -- Renames all references to the symbol under the cursor
        bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
        -- Selects a code action available at the current cursor position
        bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
        -- Show diagnostics in a floating window
        bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
      end
    })

  end,
  config = function()
    local lsp_capabilities = require'cmp_nvim_lsp'.default_capabilities()
    lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true
    require'mason-lspconfig'.setup {
      ensure_installed = { 'lua_ls' },
      automatic_installation = true,
    }
    require'mason-lspconfig'.setup_handlers {
      function(server)
        require'lspconfig'[server].setup {
          capabilities = lsp_capabilities,
        }
      end,
      ['lua_ls'] = function()
        require'lspconfig'.lua_ls.setup {
          capabilities = lsp_capabilities,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT'
              },
              diagnostics = {
                globals = {'vim'},
              },
              workspace = {
                library = {
                  vim.env.VIMRUNTIME,
                  '${3rd}/luv/library', -- squashes the fs_stat Lazy warning 
                }
              }
            }
          }
        }
      end,
      -- ['jsonls'] = function()
      --   require'lspconfig'.jsonls.setup {
      --     capabilities = lsp_capabilities,
      --   }
      -- end,
      -- ['intelephense'] = function()
      --   require'lspconfig'.intelephense.setup {
      --     capabilities = lsp_capabilities,
      --   }
      -- end,
      -- [ 'efm' ] = function()
      --   require'lspconfig'.efm.setup {
      --     init_options = {documentFormatting = true},
      --     settings = {
      --       rootMarkers = {".git/"},
      --       languages = {
      --         sh = {
      --           { formatCommand = 'shfmt -ci -s -bn' },
      --           { formatStdin = true },
      --           { lintCommand = 'shellcheck -f gcc -x' },
      --           { lintSource = 'shellcheck'},
      --           { lintFormats = { '%f:%l:%c: %trror: %m',
      --                           '%f:%l:%c: %tarning: %m',
      --                           '%f:%l:%c: %tote: %m' } },
      --           { LintIgnoreExitCode = true },
      --         }
      --       }
      --     }
      --   }
      -- end,
    }
  end,
}
