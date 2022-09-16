local packer_startup = function(use)

  local function prefer_local(url, path)
    if not path then
      path = "~/Sources/nvim/" .. url:match("[^/]*$")
    end
    return vim.loop.fs_stat(vim.fn.expand(path)) ~= nil and path or url
  end

  -- speed up 'require', must be the first plugin
  use { "lewis6991/impatient.nvim",
    config = "if vim.fn.has('nvim-0.6')==1 then require('impatient') end"
  }

  -- Packer can manage itself as an optional plugin
  use { 'wbthomason/packer.nvim', opt = true }

  -- Analyze startuptime
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }

  -- vim-surround/sandwich, lua version
  -- mini also has an indent highlighter
  use { 'echasnovski/mini.nvim',
    config = [[
        require'plugins.surround'
        require'plugins.indent'
      ]],
    event = "VimEnter"
  }

  use { -- view line in context :33
    'nacro90/numb.nvim',
    config = "require('plugins.numb')",
    event = "BufRead",
  }

  -- "gc" to comment visual regions/lines
  use { 'numToStr/Comment.nvim',
    config = "require('plugins.comment')",
    -- uncomment for lazy loading
    -- slight delay if loading in visual mode
    -- keys = {'gcc', 'gc', 'gl'}
    event = "VimEnter"
  }

  -- needs no introduction
  use { 'https://tpope.io/vim/fugitive.git',
    config = "require('plugins.fugitive')",
    event = "VimEnter"
  }

  -- plenary is required by gitsigns and telescope
  -- lazy load so gitsigns doesn't abuse our startup time
  use { "nvim-lua/plenary.nvim", event = "VimEnter" }

  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = "require('plugins.gitsigns')",
    after = "plenary.nvim" }
  -- use { prefer_local('tanvirtin/vgit.nvim'),
  --     requires = { 'nvim-lua/plenary.nvim' },
  --     config = "require('plugins.vgit')",
  --     after = "plenary.nvim" }

  -- 'famiu/nvim-reload' has been archived and no longer maintained
  use { vim.fn.stdpath("config") .. "/lua/plugins/nvim-reload",
    config = "require('plugins.nvim-reload')",
    -- skip this since we manually lazy load
    -- in our command / binding
    -- cmd = { 'NvimReload', 'NvimRestart' },
    opt = true,
  }

  -- Terminal and REPLs
  use { 'akinsho/toggleterm.nvim',
    config = "require('plugins.neoterm')",
    keys = { 'gxx', 'gx', '<C-\\>' },
    cmd = { 'T' },
  }

  -- yank over ssh with ':OCSYank' or ':OSCYankReg +'
  use { 'ojroques/vim-oscyank',
    config = [[vim.g.oscyank_term = 'tmux']],
    cmd = { 'OSCYank', 'OSCYankReg' },
  }

  -- Autocompletion & snippets
  use { 'L3MON4D3/LuaSnip',
    config = 'require("plugins.luasnip")',
    event = 'InsertEnter' }

  use { 'hrsh7th/nvim-cmp',
    requires = {
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
    },
    config = "require('plugins.cmp')",
    -- event = "InsertEnter", }
    after = 'LuaSnip'
  }

  -- nvim-treesitter
  -- verify a compiler exists before installing
  if require 'utils'.have_compiler() then
    use({
      { prefer_local('nvim-treesitter/nvim-treesitter'),
        config = "require('plugins.treesitter')",
        run = ':TSUpdate',
        event = 'BufRead'
      },
      { 'nvim-treesitter/nvim-treesitter-textobjects',
        after = { 'nvim-treesitter' }
      },
      -- debuging treesitter
      { 'nvim-treesitter/playground',
        after = { 'nvim-treesitter' },
        cmd = { 'TSPlaygroundToggle' },
      }
    })
  end

  -- optional for fzf-lua, telescope, nvim-tree
  use { 'kyazdani42/nvim-web-devicons',
    config = "require('plugins.devicons')",
    event = 'VimEnter'
  }

  -- nvim-tree
  use { 'kyazdani42/nvim-tree.lua',
    config = "require('plugins.nvim-tree')",
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFileToggle' },
  }

  -- Telescope
  use { 'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzy-native.nvim' },
    },
    setup = "require('plugins.telescope.mappings')",
    config = "require('plugins.telescope')",
    opt = true
  }

  -- only required if you do not have fzf binary
  -- use = { 'junegunn/fzf', run = './install --bin', }
  use { prefer_local('ibhagwan/fzf-lua'),
    setup = "require('plugins.fzf-lua.mappings')",
    config = "require('plugins.fzf-lua')",
    opt = true,
  }

  -- better quickfix
  use { 'kevinhwang91/nvim-bqf',
    config = "require'plugins.bqf'",
    ft = { 'qf' }
  }

  -- LSP
  use({
    { 'neovim/nvim-lspconfig', event = 'BufRead' },
    { 'williamboman/nvim-lsp-installer',
      config = "require('lsp')",
      after  = { 'nvim-lspconfig' },
    },
    { 'j-hui/fidget.nvim',
      config = [[require('fidget').setup()]],
      after  = { 'nvim-lspconfig' },
    }
  })

use({
    "jose-elias-alvarez/null-ls.nvim",
    config = [[
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.formatting.stylua,
          require("null-ls").builtins.completion.spell,
        },
      })
    ]],
    after  = { 'nvim-lspconfig' },
  })

  -- DAP
  use({
    { prefer_local('mfussenegger/nvim-dap'),
      config = "require('plugins.dap')",
      keys = { '<F5>', '<F8>', '<F9>' }
    },
    { 'rcarriga/nvim-dap-ui',
      config = "require('plugins.dap.ui')",
      after = { 'nvim-dap' }
    },
    { 'jbyuki/one-small-step-for-vimkind',
      after = { 'nvim-dap' }
    }
  })

  -- ethereum solidity '.sol'
  use { 'tomlion/vim-solidity' }

  -- markdown preview using `glow`
  -- use { 'npxbr/glow.nvim', run = ':GlowInstall'}
  use { 'previm/previm',
    commit = "1978acc23c16cddcaf70c856a3b39d17943d7df0",
    config = [[
      -- vim.g.previm_open_cmd = 'firefox';
      vim.g.previm_open_cmd = '/shared/$USER/Applications/chromium/chrome';
      vim.g.previm_enable_realtime = 0
      vim.g.previm_disable_default_css = 1
      vim.g.previm_custom_css_path = vim.fn.stdpath("config").."/css/previm-gh-dark.css"
      -- clear cache every time we open neovim
      vim.fn['previm#wipe_cache']()
    ]],
    ft = { 'markdown' },
    opt = true,
  }

  use {
    "karb94/neoscroll.nvim",
    opt = true,
    event = "WinScrolled",
    keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
    config = "require('plugins.neoscroll')",
  }

  use {
    "olimorris/persisted.nvim",
    config = "require('plugins.persisted')",
  }

  -- key bindings cheatsheet
  use { 'folke/which-key.nvim',
    config = "require('plugins.which_key')",
    event = "VimEnter"
  }

  -- Color scheme, requires nvim-treesitter
--  use { "bluz71/vim-nightfly-guicolors" }

  use { "EdenEast/nightfox.nvim",
    config = "require('plugins.nightfox')",
  }
  
  -- Colorizer
  use { 'norcalli/nvim-colorizer.lua',
    config = "require'colorizer'.setup()",
    cmd = { 'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer' },
    opt = true
  }

  use { 'nvim-lualine/lualine.nvim',
    config = "require('plugins.lualine')",
  }

  use { 'romgrk/barbar.nvim',
    config = "require('plugins.barbar')",
  }

  -- statusline
--  use { 'tjdevries/express_line.nvim',
--    config = "require('plugins.statusline')",
--    requires = { 'nvim-lua/plenary.nvim' },
--    after = 'plenary.nvim',
    -- after = { 'plenary.nvim', 'nvim-web-devicons' },
    -- event = 'VimEnter',
--  }

  -- auto-generate vimdoc from GitHub README
  use { prefer_local('ibhagwan/ts-vimdoc.nvim'),
    setup = "require'plugins.ts-vimdoc'",
    opt = true
  }

end

return packer_startup
