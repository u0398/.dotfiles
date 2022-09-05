local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

function get_config(name)
  return string.format('require("user/%s")', name)
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)

  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use {"nvim-lua/popup.nvim", opt = true } -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins
  use { -- Show colors in neovim (Red, Green, Blue, etc.)
    'norcalli/nvim-colorizer.lua',
    opt = true,
    cmd = { 'ColorizerToggle' },
    config = function() require'colorizer'.setup() end
  }

  use({ "sainnhe/sonokai" })

  use({ "sunjon/Shade.nvim", config = get_config("shade") })

  use({ "famiu/bufdelete.nvim" }) -- config = get_config("bufdelete")})

  use({ -- view line in context :33
    "nacro90/numb.nvim",
    config = get_config("numb"),
    event = "BufRead",
  })

  use({
    "windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter
    config = get_config("autopairs"),
    after = 'nvim-cmp',
    -- event = "BufRead",
  })

  use({
    "karb94/neoscroll.nvim",
    opt = true,
    event = "WinScrolled",
    keys = {'<C-u>', '<C-d>',-- '<C-b>', '<C-f>',
            '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    config = get_config("neoscroll"),
  })

  use({ "ryanoasis/vim-devicons" })
  use({ "kyazdani42/nvim-web-devicons" })

  use({"romgrk/barbar.nvim",
    config = get_config("barbar"),

  })


  -- Easily comment stuff
--  use ({"JoosepAlviste/nvim-ts-context-commentstring" })

  use({ "numToStr/Comment.nvim",
    config = get_config("comment"),
--    keys = { "gc", "gcc", "gbc" }, -- it makes commet plugin lazy load
--    requires = {"JoosepAlviste/nvim-ts-context-commentstring"}
  })

    -- Lua
--    use({
--        "olimorris/persisted.nvim",
--        -- event = "BufReadPre", -- this will only start session saving when an actual file was opened
--        -- module = "persisted",
--        config = function()
--            require("persisted").setup()
--        end,
--    })

  use ({'monkoose/matchparen.nvim', config = get_config("matchparen") })

  -- colorschemes
  use({
    "EdenEast/nightfox.nvim",
    config = get_config("nightfox")
  })
--	use ({"tanvirtin/monokai.nvim", config = get_config("monokai") }) -- show cursor on jumps
--  use ({"mvpopuk/inspired-github.vim"})
--  use ({'tanvirtin/monokai.nvim'})
--  use({"ellisonleao/gruvbox.nvim", requires = { "rktjmp/lush.nvim" } })
--  use "Shatur/neovim-ayu"
--  use 'marko-cerovac/material.nvim'
--  use("shaunsingh/nord.nvim")
--  use({"navarasu/onedark.nvim"})
--  use({"cocopon/iceberg.vim"})
--  use({"folke/tokyonight.nvim"})
--  use({"lunarvim/darkplus.nvim"})
--  use("Mofiqul/dracula.nvim")
--  use({
--    'rose-pine/neovim',
--     as = 'rose-pine',
--     tag = 'v1.*',
--     config = function()
--       vim.cmd('colorscheme rose-pine')
--     end
--  })
--	use({
--		"catppuccin/nvim",
--		as = "catppuccin"
--	})
--	use "savq/melange"

    -- Linux users: you must install wmctrl to be able to automatically switch to
    -- the Vim window with the open file. wmctrl is already packaged for most
    -- distributions. (autoswap dependency)
--    use({ "gioele/vim-autoswap" })
	use ({"DanilaMihailov/beacon.nvim", config = get_config("beacon") }) -- show cursor on jumps
  -- use ({"kyazdani42/nvim-web-devicons", module = "nvim-web-devicons",})
  use ({"kyazdani42/nvim-tree.lua",
		opt = true,
    cmd = { 'NvimTreeToggle' },
    config = get_config("nvim-tree")
  })
    --     'romgrk/barbar.nvim',
    --     requires = {'kyazdani42/nvim-web-devicons'},
    --     config = get_setup("barbar")
    -- }
  use ({"nvim-lualine/lualine.nvim", config = get_config("lualine")})
  use ({"akinsho/toggleterm.nvim", config = get_config("toggleterm")})
  
    -- use "ahmedkhalf/project.nvim"
--    use ({"lewis6991/impatient.nvim", config = get_setup("impatient")})
--    use ({"lukas-reineke/indent-blankline.nvim",
--        config = get_setup("indentline"),
--        event = "BufRead",
--    })
    -- use ({"goolord/alpha-nvim", config = get_setup("alpha") })

--    use ({"antoinemadec/FixCursorHold.nvim",
--        config = get_setup("fixcursorhold"),
--        event = "BufRead",
--    }) -- This is needed to fix lsp doc highlight

--    use 'tjdevries/nlua.nvim'
  use({ "nathom/filetype.nvim", config = get_config("filetype") })
  use "folke/which-key.nvim"

    -- cmp plugins
  use ({"hrsh7th/nvim-cmp", config = get_config("cmp") }) -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"

    -- snippets
--    use "L3MON4D3/LuaSnip" --snippet engine
--    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
--  use ({ "MunifTanjim/prettier.nvim",
--    config = get_config("prettier")
--  })

  -- Telescope
  use ({"nvim-telescope/telescope.nvim",
    config = get_config("telescope"),
    module = "telescope",
    cmd = "Telescope",
    -- keys = {
    --     {"", "<C-p>"},
    --     {"", "<C-f>"},
    --     {"n", "<Leader>f"}
    -- },
  })

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    module = 'nvim-treesitter',
    event = "BufRead",
    config = get_config("treesitter"),
  }

    -- Git
  use ({"lewis6991/gitsigns.nvim",
    config = get_config("gitsigns"),
    setup = function()
      require("core.utils").packer_lazy_load "gitsigns.nvim"
    end,
  })
    
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)

