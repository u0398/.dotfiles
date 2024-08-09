-- hrsh7th/nvim-cmp
-- completion engine plugin for neovim written in Lua
return {
  'hrsh7th/nvim-cmp',
  event = "InsertEnter",
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-cmdline',
  },
  config = function()
  local select_opts = {behavior = require'cmp'.SelectBehavior.Select}

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  -- require("luasnip.loaders.from_vscode").lazy_load()

  require'cmp'.setup {
    snippet = {
      expand = function(args)
        require'luasnip'.lsp_expand(args.body)
      end
    },
    sources = {
      {name = 'path', keyword_length = 2},
      {name = 'nvim_lsp', keyword_length = 2},
      {name = 'nvim_lua', keyword_length = 2},
      {name = 'cmdline', keyword_length = 2},
      {name = 'buffer', keyword_length = 3},
      {name = 'luasnip', keyword_length = 2},
    },
    window = {
      completion = require'cmp'.config.window.bordered(),
      documentation = require'cmp'.config.window.bordered()
    },
    formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
        local menu_icon = {
          nvim_lsp = 'λ',
          luasnip = '⋗',
          buffer = 'Ω',
          path = '🖫',
        }

        item.menu = menu_icon[entry.source.name]
        return item
      end,
    },
    mapping = {
      ['<Up>'] = require'cmp'.mapping.select_prev_item(select_opts),
      ['<Down>'] = require'cmp'.mapping.select_next_item(select_opts),

      ['<C-p>'] = require'cmp'.mapping.select_prev_item(select_opts),
      ['<C-n>'] = require'cmp'.mapping.select_next_item(select_opts),

      ['<C-u>'] = require'cmp'.mapping.scroll_docs(-4),
      ['<C-d>'] = require'cmp'.mapping.scroll_docs(4),

      ['<C-e>'] = require'cmp'.mapping.abort(),
      ['<C-y>'] = require'cmp'.mapping.confirm({select = true}),
      ['<CR>'] = require'cmp'.mapping.confirm({select = false}),

      ['<C-f>'] = require'cmp'.mapping(function(fallback)
        if require'luasnip'.jumpable(1) then
          require'luasnip'.jump(1)
        else
          fallback()
        end
      end, {'i', 's'}),

      ['<C-b>'] = require'cmp'.mapping(function(fallback)
        if require'luasnip'.jumpable(-1) then
          require'luasnip'.jump(-1)
        else
          fallback()
        end
      end, {'i', 's'}),
      ['<Tab>'] = require'cmp'.mapping(function(fallback)
        local col = vim.fn.col('.') - 1

        if require'cmp'.visible() and has_words_before() then
          require'cmp'.select_next_item(select_opts)
        elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          fallback()
        else
          require'cmp'.complete()
        end
      end, {'i', 's'}),

      ['<S-Tab>'] = require'cmp'.mapping(function(fallback)
        if require'cmp'.visible() then
          require'cmp'.select_prev_item(select_opts)
        else
          fallback()
        end
      end, {'i', 's'}),
    },
  }
  end
}
