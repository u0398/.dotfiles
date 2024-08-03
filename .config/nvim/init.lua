-- bootstrap lazy.nvim {{{1
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
  float = {
    border = "rounded",
    format = function(d)
      return ("%s (%s) [%s]"):format(d.message, d.source, d.code or d.user_data.lsp.code)
    end,
  },
  underline = true,
  jump = {
    float = true,
  },
}

      -- [vim.diagnostic.severity.ERROR] = "",
      -- [vim.diagnostic.severity.WARN] = "",
      -- [vim.diagnostic.severity.INFO] = "",
      -- [vim.diagnostic.severity.HINT] = "",

-- local symbols = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
--
-- for name, icon in pairs(symbols) do
--     local hl = "DiagnosticSign" .. name
--     vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
-- end

-- options {{{1

local o = vim.opt

o.rtp:prepend(lazypath)         -- add lazypath to runtimepath

o.mouse             = 'a'       -- disable the mouse
o.exrc              = false     -- ignore '~/.exrc'
o.secure            = true
o.modelines         = 1         -- read a modeline at EOF
o.errorbells        = false     -- disable error bells (no beep/flash)
o.termguicolors     = true      -- enable 24bit colors

o.updatetime        = 250       -- decrease update time
o.autoread          = true      -- auto read file if changed outside of vim
o.fileformat        = 'unix'    -- <nl> for EOL
o.switchbuf         = 'useopen' -- jump to the first open window containing specified 
                                -- buffer, but not windows in other tab pages
o.encoding          = 'utf-8'
o.fileencoding      = 'utf-8'
o.backspace         = { 'eol', 'start', 'indent' }
o.matchpairs        = { '(:)', '{:}', '[:]', '<:>' }

o.modifiable        = true

o.showtabline       = 0

vim.cmd[[set path=.,,,$PWD/**]] -- recursive :find in current dir

-- vim clipboard copies to system clipboard
o.clipboard         = 'unnamedplus' -- unamed (uses * register) | unnamedplus (uses + register)

o.showmode          = false     -- show current mode (insert, etc) under the cmdline
o.showcmd           = true      -- show current command under the cmd line
o.cmdheight         = 1         -- cmdline height
o.cmdwinheight      = math.floor(vim.o.lines/2) -- 'q:' window height
-- o.laststatus        = vim.fn.has('nvim-0.7')==1 and 3 or 2  -- global statusline
o.laststatus        = 2         -- 2 = always show status line (filename, etc)
o.scrolloff         = 3         -- min number of lines to keep between cursor and screen edge
o.sidescrolloff     = 5         -- min number of cols to keep between cursor and screen edge
o.textwidth         = 78        -- max inserted text width for paste operations
o.linespace         = 0         -- font spacing
o.ruler             = true      -- show line,col at the cursor pos
o.number            = true      -- show absolute line no. at the cursor pos
o.relativenumber    = true      -- otherwise, show relative numbers in the ruler
o.cursorline        = true      -- Show a line where the current cursor is
o.signcolumn        = 'yes'     -- Show sign column as first column
--vim.g.colorcolumn   = 81        -- global var, mark column 81
--o.colorcolumn       = tostring(vim.g.colorcolumn)
o.wrap              = true      -- wrap long lines
o.breakindent       = true      -- start wrapped lines indented
o.linebreak         = true      -- do not break words on line wrap

o.fillchars         = 'foldsep: '

-- Characters to display on ':set list',explore glyphs using:
-- `xfd -fa "InputMonoNerdFont:style:Regular"` or
-- `xfd -fn "-misc-fixed-medium-r-semicondensed-*-13-*-*-*-*-*-iso10646-1"`
-- input special chars with the sequence <C-v-u> followed by the hex code
o.list      = false
o.listchars = {
  tab       = '→ '  ,
  eol       = '↲'   ,
  nbsp      = '␣'   ,
  lead      = '·'   ,
  space     = '·'   ,
  trail     = '•'   ,
  extends   = '⟩'   ,
  precedes  = '⟨'   ,
}
o.showbreak = '↪ '

-- show menu even for one item do not auto select/insert
o.completeopt       = {'menu', 'menuone', 'noselect'}
--o.completeopt       = { 'noinsert' , 'menuone' , 'noselect' }
o.wildmenu          = true
o.wildmode          = 'longest:full,full'
o.wildoptions       = 'pum'     -- Show completion items using the pop-up-menu (pum)
o.pumblend          = 15        -- completion menu transparency

o.joinspaces        = true      -- insert spaces after '.?!' when joining lines
o.autoindent        = true      -- copy indent from current line on newline
o.smartindent       = true      -- add <tab> depending on syntax (C/C++)
o.startofline       = false     -- keep cursor column on navigation

o.tabstop           = 2         -- Tab indentation levels every two columns
o.softtabstop       = 2         -- Tab indentation when mixing tabs & spaces
o.shiftwidth        = 2         -- Indent/outdent by two columns
o.shiftround        = true      -- Always indent/outdent to nearest tabstop
o.expandtab         = true      -- Convert all tabs that are typed into spaces
o.smarttab          = true      -- Use shiftwidths at left margin, tabstops everywhere else

-- c: auto-wrap comments using textwidth
-- r: auto-insert the current comment leader after hitting <Enter>
-- o: auto-insert the current comment leader after hitting 'o' or 'O'
-- q: allow formatting comments with 'gq'
-- n: recognize numbered lists
-- 1: don't break a line after a one-letter word
-- j: remove comment leader when it makes sense
-- this gets overwritten by ftplugins (:verb set fo)
-- we use autocmd to remove 'o' in '/lua/autocmd.lua'
-- borrowed from tjdevries
o.formatoptions = o.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore

o.splitbelow        = true      -- ':new' ':split' below current
o.splitright        = true      -- ':vnew' ':vsplit' right of current

o.foldcolumn        = '1'
o.foldenable        = true      -- enable folding
o.foldlevel         = 99
o.foldlevelstart    = 99        -- open most folds by default
o.foldnestmax       = 50        -- 10 nested fold max
o.foldmethod        = 'indent'  -- fold based on indent level

o.undofile          = false     -- no undo file
o.hidden            = true      -- do not unload buffer when abandoned
o.autochdir         = false     -- do not change dir when opening a file

o.magic             = true      --  use 'magic' chars in search patterns
o.hlsearch          = true      -- highlight all text matching current search pattern
o.incsearch         = true      -- show search matches as you type
o.ignorecase        = true      -- ignore case on search
o.smartcase         = true      -- case sensitive when search includes uppercase
o.showmatch         = true      -- highlight matching [{()}]
o.inccommand        = 'nosplit' -- show search and replace in real time
o.autoread          = true      -- reread a file if it's changed outside of vim
o.wrapscan          = true      -- begin search from top of the file when nothing is found
vim.o.cpoptions     = vim.o.cpoptions .. 'x' -- stay on search item when <esc>

o.whichwrap = "<,>,h,l,[,]"     -- wrap to next line when moving cursor to beginning/end of line

o.backup            = false     -- no backup file
o.writebackup       = false     -- do not backup file before write
o.swapfile          = false     -- no swap file

--[[
  ShDa (viminfo for vim): session data history
  --------------------------------------------
  ! - Save and restore global variables (their names should be without lowercase letter).
  ' - Specify the maximum number of marked files remembered. It also saves the jump list and the change list.
  < - Maximum of lines saved for each register. All the lines are saved if this is not included, <0 to disable pessistent registers.
  % - Save and restore the buffer list. You can specify the maximum number of buffer stored with a number.
  / or : - Number of search patterns and entries from the command-line history saved. o.history is used if it’s not specified.
  f - Store file (uppercase) marks, use 'f0' to disable.
  s - Specify the maximum size of an item’s content in KiB (kilobyte).
      For the viminfo file, it only applies to register.
      For the shada file, it applies to all items except for the buffer list and header.
  h - Disable the effect of 'hlsearch' when loading the shada file.

  :oldfiles - all files with a mark in the shada file
  :rshada   - read the shada file (:rviminfo for vim)
  :wshada   - write the shada file (:wrviminfo for vim)
]]
o.shada             = [[!,'100,<0,s100,h]]
o.sessionoptions    = 'buffers,curdir,folds,globals,tabpages,winpos,winsize'
o.diffopt           = 'internal,filler,algorithm:histogram,indent-heuristic'

-- use ':grep' to send resulsts to quickfix
-- use ':lgrep' to send resulsts to loclist
if vim.fn.executable('rg') == 1 then
    o.grepprg = 'rg --vimgrep --no-heading --smart-case --hidden'
    o.grepformat = '%f:%l:%c:%m'
end

-- Disable providers we do not care a about
vim.g.loaded_python_provider  = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_node_provider    = 0

-- Disable some in built plugins completely
local disabled_built_ins = {
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'logipat',
  'rrhelper',
  'spellfile_plugin',
  'fzf',
  -- 'matchit',
   --'matchparen',
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

vim.g.markdown_fenced_languages = {
  'vim',
  'lua',
  'cpp',
  'sql',
  'python',
  'bash=sh',
  'console=sh',
  'javascript',
  'typescript',
  'js=javascript',
  'ts=typescript',
  'yaml',
  'json',
}

-- using catppuccin custom highlights instead
--local hi = vim.api.nvim_set_hl
--hi(0,'TermCursorNC', { fg='#24273a', bg='#a5adcb' })
--hi(0,'Folded', { bg='NONE' })

  vim.api.nvim_command('set rtp-=/usr/share/vim/vimfiles') -- do not load system fzf.vim (Arch, etc.)

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- load plugins with lazy.nvim {{{1
require('lazy').setup {
  spec = {
    { 'nvim-lua/plenary.nvim', lazy = false, },
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', },
    { 'nvim-tree/nvim-tree.lua',
      version = '*',
      lazy = false,
      dependencies = {
        { 'nvim-tree/nvim-web-devicons',  lazy = false },
      },
      config = function()
        require('nvim-tree').setup {}
      end,
    },
    { 'kevinhwang91/nvim-ufo',
      dependencies = {
        'kevinhwang91/promise-async',
      },
    },
    { 'kylechui/nvim-surround',
      version = '*', -- Use for stability; omit to use `main` branch for the latest features
      event = 'VeryLazy',
      config =
        function()
          require('nvim-surround').setup()
        end
    },
    { 'tversteeg/registers.nvim',
      cmd = 'Registers',
      config = function()
        local registers = require("registers")
        registers.setup {
          window = {
            border = 'rounded',
            transparency = 0,
          }
        }
      end,
      keys = {
        { '"',     mode = { 'n', 'v' } },
        { '<C-R>', mode = 'i' }
      },
      name = "registers",
    },
    { 'smoka7/hop.nvim', version = 'v2.*', event = 'VeryLazy' },
    { 'luukvbaal/statuscol.nvim' },
    -- { 'echasnovski/mini.nvim', version = '*' },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    { 'lewis6991/gitsigns.nvim' },
    { 'nvim-treesitter/nvim-treesitter' },
    { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
    { 'karb94/neoscroll.nvim' },
    { 'ibhagwan/fzf-lua' },
    -- { 'numToStr/Comment.nvim' },
    { "folke/which-key.nvim", event = "VeryLazy",
      keys = {
        {
          "<leader><space>",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },
    { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },
    { 'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
      dependencies = {
        'rafamadriz/friendly-snippets'
      },
    },
    { 'williamboman/mason.nvim',
      dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-cmdline',
      },
      -- event = "filetype",
    },
    -- { 'romgrk/barbar.nvim' },
    -- { 'nvim-lualine/lualine.nvim' },
    { 'rebelot/heirline.nvim' },
    { 'j-hui/fidget.nvim' },
    { 'gennaro-tedesco/nvim-possession',
      lazy = false,
      dependencies = {
        { 'tiagovla/scope.nvim',
          lazy = false,
          config = true,
        },
        { 'ibhagwan/fzf-lua' },
      },
    },
  },
  checker = { enabled = true },
}

-- plugin setup {{{1

-- nvim-telescope/telescope.nvim {{{2
-- gaze deeply into unknown regions using the power of the moon.
local telescope_loaded, telescope = pcall(require, 'telescope')
if telescope_loaded then
  telescope.setup {
    defaults = {
      layout_strategy = 'vertical',
      layout_config = {
        height = 0.9,
        width = 0.9,
      },
    },
  }
end

-- lewis6991/gitsigns.nvim {{{2
-- git decorations implemented purely in Lua
local gitsigns_loaded, gitsigns = pcall(require, 'gitsigns')
if gitsigns_loaded then
  gitsigns.setup()
end

-- nvim-tree/nvim-tree.lua {{{2
-- A File Explorer For Neovim Written In Lua
local nvim_tree_loaded, nvim_tree = pcall(require, 'nvim-tree')
if nvim_tree_loaded then
  nvim_tree.setup {
    disable_netrw = true,
    hijack_cursor = true,
    hijack_netrw = false,
    update_cwd = true,
    view = {
      width = 40,
      side = 'left',
      --mappings = {
      --  custom_only = false,
      --  list = {
      --    { key = "<C-x>", action = nil },
      --    { key = "<C-s>", action = "split" },
      --  }
      --}
    },
    renderer = {
      indent_markers = {
        enable = true,
        icons = {
          corner = "└ ",
          edge = "│ ",
          none = "  ",
        },
      },
      icons = {
        symlink_arrow = " → ",  -- ➜ → ➛
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
        glyphs = {
          git = {
            -- staged      = "✓",
            -- renamed     = "➜",
            -- renamed     = "→",
            unstaged    = "U",
            staged      = "S",
            unmerged    = "M",
            renamed     = "R",
            untracked   = "?",
            deleted     = "✗",
            ignored     = "◌",
          },
        },
      },
      special_files = {
        "README.md",
        "LICENSE",
        "Cargo.toml",
        "Makefile",
        "package.json",
        "package-lock.json",
      }
    },
    diagnostics = {
      enable = true,
      show_on_dirs = false,
      icons = {
        hint = "", -- "",
        info = "",
        warning = "",
        error = "",
      },
    },
    filters = {
      dotfiles = false,
      custom = {
        "\\.git",
        ".cache",
        "node_modules",
        "__pycache__",
      }
    },
    git = {
      enable = true,
      ignore = false,
      timeout = 400,
    },
    actions = {
      use_system_clipboard = false,
      change_dir = {
        enable = false,
        global = false,
        restrict_above_cwd = false,
      },
      open_file = {
        quit_on_open = true,
        resize_window = true,
      },
    },
  }
end

-- kevinhwang91/nvim-ufo {{{2
-- make Neovim's fold look modern and keep high performance
local ufo_loaded, ufo = pcall(require, 'ufo')
if ufo_loaded then

  local fold_handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d'):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, {chunkText, hlGroup})
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
  end

  ufo.setup {
    open_fold_hl_timeout = 0,
    provider_selector =
      function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
      end,
    fold_virt_text_handler = fold_handler,

  }
end

-- smoka7/hop.nvim
-- an EasyMotion-like plugin allowing you to jump anywhere in a document
local hop_loaded, hop =pcall(require, 'hop')
if hop_loaded then
  hop.setup {
    quit_key = '<Esc>',
  }
end

-- luukvbaal/statuscol.nvim {{{2
-- status column plugin that provides a configurable 'statuscolumn' and click handlers
local statuscol_loaded, statuscol = pcall(require, 'statuscol')
if statuscol_loaded then
  local builtin = require('statuscol.builtin')

  statuscol.setup {
    setopt = true,
    thousands = false,
    relculright = true,
    segments = {
      { text = { builtin.foldfunc }, colwidth = 2, click = "v:lua.ScFa" },
      {
        sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
        click = "v:lua.ScSa",
      },
      { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
      {
        sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false, wrap = true },
          click = "v:lua.ScSa"
      },
    },
  }
end

-- echasnovski/mini.nvim (mini-animate) {{{2
-- animate common Neovim actions
-- local mini_animate_loaded, mini_animate = pcall(require, 'mini.animate')
-- if mini_animate_loaded then
--   mini_animate.setup()
-- end

-- echasnovski/mini.indentscope {{{2
-- visualize and work with indent scope
local mini_indentscope_loaded, mini_indentscope = pcall(require, 'mini.indentscope')
if mini_indentscope_loaded then
  mini_indentscope.setup {
    draw = {
      delay = 100,
      -- Animation rule for scope's first drawing. A function which, given
      -- next and total step numbers, returns wait time (in ms). See
      -- |MiniIndentscope.gen_animation| for builtin options. To disable
      -- animation, use `require('mini.indentscope').gen_animation.none()`.
      animation = mini_indentscope.gen_animation.quadratic({ easing = 'out', duration = 50, unit = 'total' }),
      priority = 2,
    },
      mappings = { -- Use `''` (empty string) to disable one.
      -- Textobjects
      object_scope = 'ii',
      object_scope_with_border = 'ai',
      -- Motions (jump to respective border line; if not present - body line)
      goto_top = '[i',
      goto_bottom = ']i',
    },
    -- Options which control scope computation
    options = {
      border = 'both',  -- both|top|bottom|none'
      indent_at_cursor = true,
      try_as_border = false,
    },
    symbol = '│',
  }
end

-- echasnovski/mini.icons {{{2
-- icon provider
local mini_icons_loaded, mini_icons = pcall(require, 'mini.icons')
if mini_icons_loaded then
  mini_icons.setup()
end

-- nvim-treesitter/nvim-treesitter {{{2
-- Improved tree-sitter hilighting
local nvim_treesitter_loaded, nvim_treesitter = pcall(require, 'nvim-treesitter.configs')
if nvim_treesitter_loaded then
  nvim_treesitter.setup {
    ensure_installed = {
      "bash",
      --"c",
      --"cpp",
      --"go",
      "javascript",
      "typescript",
      "json",
      "jsonc",
      "jsdoc",
      "lua",
      "python",
      --"rust",
      "html",
      "css",
      "toml",
      "markdown",
      "markdown_inline",
      -- for `nvim-treesitter/playground`
      "query",
      "vimdoc"
    },
    highlight   = {
      enable = true,
      -- slow on big files
      -- ugly for markdown
      disable = {
        -- "c", "cpp",
        "md", "markdown",
      }
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<cr>',
        node_incremental = '<cr>',
        node_decremental = '<bs>',
        scope_incremental = false,
      },
    },
  }
end

-- catppuccin/nvim {{{2 
-- catppuccin for (Neo)vim
local catppuccin_loaded, catppuccin = pcall(require, 'catppuccin')
if catppuccin_loaded then
  catppuccin.setup {
    flavour = "macchiato", -- auto, latte, frappe, macchiato, mocha
    background = { -- :h background
      light = "macchiato",
      dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
    -- dim_inactive = {
    --   enabled = true, -- dims the background color of inactive window
    --   shade = "dark",
    --   percentage = 0.01, -- percentage of the shade to apply to the inactive window
    -- },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { "italic" }, -- Change the style of comments
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = function(colors)
      return {
        NormalNC = { bg = colors.mantle },
        Folded = { bg = colors.surface0 },
        TermCursorNC = { fg = colors.base, bg = colors.subtext0 },
        StatusLine = { bg = colors.base },
        StatusLineNC = { bg = colors.mantle },
        NotifyERRORBorder = { fg = colors.red },
        NotifyWARNBorder = { fg = colors.peach },
        NotifyINFOBorder = { fg = colors.yellow },
        NotifyDEBUGBorder = { fg = colors.lavender },
        NotifyTRACEBorder = { fg = colors.mauve },
        NotifyERRORIcon = { fg = colors.red },
        NotifyWARNIcon = { fg = colors.peach },
        NotifyINFOIcon = { fg = colors.yellow },
        NotifyDEBUGIcon = { fg = colors.lavender },
        NotifyTRACEIcon = { fg = colors.mauve },
        NotifyERRORTitle = { fg = colors.red },
        NotifyWARNTitle = { fg = colors.peach },
        NotifyINFOTitle = { fg = colors.yellow },
        NotifyDEBUGTitle = { fg = colors.lavender },
        NotifyTRACETitle = { fg = colors.mauve },
        -- NotifyERRORBody = { bg = colors.surface0 },
        -- NotifyWARNBody = { bg = colors.surface0 },
        -- NotifyINFOBody = { bg = colors.surface0 },
        -- NotifyDEBUGBody = { bg = colors.surface0 },
        -- NotifyTRACEBody = { bg = colors.surface0 },
        HeirDiagnosticPrefix = { fg = colors.flamingo, bg = colors.base },
        HeirDiagnosticPrefixInactive = { fg = colors.flamingo, bg = colors.mantle },
      }
    end,
    default_integrations = true,
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = false,
      mini = {
        enabled = true,
        indentscope_color = "surface0",
      },
      -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
  }
  vim.cmd.colorscheme "catppuccin"
end

-- romgrk/barbar.nvim {{{2  
-- Fancy tabline plugin
local plugin_loaded, barbar = pcall(require, 'barbar')
if plugin_loaded then
--  local barbar_color = vim.api.nvim_set_h1
  vim.api.nvim_set_hl( 0, 'BufferCurrent', { fg = "#444444", bg = "#ffffff" } )
  vim.api.nvim_set_hl( 0, 'BufferCurrentBtn', { fg = "#444444", bg = "#ffffff" } )
  vim.api.nvim_set_hl( 0, 'BufferCurrentMod', { fg = "#0c3e22", bg = "#25be6a" } )
  vim.api.nvim_set_hl( 0, 'BufferCurrentModBtn', { fg = "#0c3e22", bg = "#25be6a" } )
  vim.api.nvim_set_hl( 0, 'BufferVisible', { fg = "#ffffff", bg = "#444444" } )
  vim.api.nvim_set_hl( 0, 'BufferVisibleBtn', { fg = "#ffffff", bg = "#444444" } )
  vim.api.nvim_set_hl( 0, 'BufferVisibleSign', { fg = "#444444", bg = "#111111" } )
  vim.api.nvim_set_hl( 0, 'BufferVisibleMod', { fg = "#2ce47f", bg = "#0c3e22" } )
  vim.api.nvim_set_hl( 0, 'BufferInactive', { fg = "#ffffff", bg = "#444444" } )
  vim.api.nvim_set_hl( 0, 'BufferInactiveBtn', { fg = "#ffffff", bg = "#444444" } )
  vim.api.nvim_set_hl( 0, 'BufferInactiveSign', { fg = "#444444", bg = "#111111" } )
  vim.api.nvim_set_hl( 0, 'BufferInactiveMod', { fg = "#2ce47f", bg = "#0c3e22" } )

  barbar.setup {
    --vim.g.bufferline = {
    animation = true,    -- Enable/disable animations
    auto_hide = false,   -- Enable/disable auto-hiding the tab bar when there is a single buffer
    tabpages = true,     -- Enable/disable current/total tabpages indicator (top right corner)
    closable = true,     -- Enable/disable close button
    clickable = true,    -- Enables/disable clickable tabs - left-click: go to buffer - middle-click: delete buffer

    -- Excludes buffers from the tabline
    --exclude_ft = {'javascript'},
    --exclude_name = {'package.json'},

    icons = {
      filetype = {
        enabled = false,
        custom_colors = false
      },
      separator = {left = '', right = ''},
      separator_at_end = false,
      modified = {button = '●'},
      pinned = {button = '', filename = true},

      preset = 'default',

      alternate = {filetype = {enabled = false}},
      current = {buffer_index = false},
      inactive = {
        button = '×',
        separator = {left = '', right = ''},
      },
      visible = {modified = {buffer_number = false}},
    },

    -- If true, new buffers will be inserted at the start/end of the list.
    -- Default is to insert after current buffer.
    insert_at_end = true,
    insert_at_start = false,

    maximum_padding = 0,    -- Sets the maximum padding width with which to surround each tab
    maximum_length = 30,    -- Sets the maximum buffer name length.

    -- If set, the letters for each buffer in buffer-pick mode will be
    -- assigned based on their name. Otherwise or in case all letters are
    -- already assigned, the behavior is to assign letters in order of
    -- usability (see order below)
    semantic_letters = true,
    sidebar_filetypes = {
      NvimTree = true,
    },
    -- New buffer letters are assigned in this order. This order is
    -- optimal for the qwerty keyboard layout but might need adjustement
    -- for other layouts.
    letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

    -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
    -- where X is the buffer number. But only a static string is accepted here.
    no_name_title = nil,
  }
end

-- karb94/neoscroll.nvim {{{2
-- A smooth scrolling neovim plugin
local neoscroll_loaded, neoscroll = pcall(require, 'neoscroll')
if neoscroll_loaded then
  neoscroll.setup {
    -- All these keys will be mapped to their corresponding default scrolling animation
    --mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
    hide_cursor = true, -- Hide cursor while scrolling
    stop_eof = true, -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil, -- Default easing function
    pre_hook = nil, -- Function to run before the scrolling animation starts
    post_hook = nil, -- Function to run after the scrolling animation ends
  }
end

-- rebelot/heirline.nvim {{{2
-- the ultimate Neovim Statuslie for tinkerers
local heirline_loaded, heirline = pcall(require, 'heirline')
if heirline_loaded then

  local heir_conditions = require("heirline.conditions")
  local heir_utils = require("heirline.utils")

  local colorscheme_colors = require("catppuccin.palettes").get_palette "macchiato"
  local heir_colors = {
    mode_normal    = colorscheme_colors.blue,
    mode_insert    = colorscheme_colors.green,
    mode_visual    = colorscheme_colors.mauve,
    mode_command   = colorscheme_colors.peach,
    mode_select    = colorscheme_colors.pink,
    mode_replace   = colorscheme_colors.peach,
    mode_executing = colorscheme_colors.red,
    mode_terminal  = colorscheme_colors.yellow,

    statusline           = colorscheme_colors.base,
    statusline_inactive  = colorscheme_colors.mantle,
    bg                   = colorscheme_colors.surface0,
    bg_inactive          = colorscheme_colors.surface0,
    text                 = colorscheme_colors.text,
    text_inactive        = colorscheme_colors.surface2,
    prefix               = colorscheme_colors.surface2,
    prefix_inactive      = colorscheme_colors.surface2,
    prefix_text          = colorscheme_colors.base,
    prefix_text_inactive = colorscheme_colors.base,

    file_name         = colorscheme_colors.green,
    file_name_locked  = colorscheme_colors.peach,
    help              = colorscheme_colors.green,
    diagnostics       = colorscheme_colors.flamingo,
    git               = colorscheme_colors.teal,
    git_added         = colorscheme_colors.green,
    git_removed       = colorscheme_colors.red,
    git_changed       = colorscheme_colors.yellow,
    git_parenthese    = colorscheme_colors.overlay0,
    file_properties   = colorscheme_colors.mauve,

    ERROR = colorscheme_colors.red,
    WARN  = colorscheme_colors.peach,
    INFO  = colorscheme_colors.yellow,
    HINT  = colorscheme_colors.teal,
  }

  local heir_block_prefix = { provider = '' }
  local heir_block_suffix = { provider = '' }
  local heir_block_spacer = { provider = ' ' }

  local heir_block_suffix_modifier = {
    hl = function()
      if heir_conditions.is_active() then
        return { fg = 'bg', bg = 'statusline' }
      else
        return { fg = 'bg_inactive', bg = 'statusline_inactive' }
      end
    end
  }

  heir_block_suffix = heir_utils.insert( heir_block_suffix_modifier, heir_block_suffix )

  local heir_mode = {
    init = function(self)
      self.mode = vim.fn.mode(1)
    end,
    static = {
      mode_names = {
        n = "N",
        no = "N?",
        nov = "N?",
        noV = "N?",
        ["no\22"] = "N?",
        niI = "Ni",
        niR = "Nr",
        niV = "Nv",
        nt = "Nt",
        v = "V",
        vs = "Vs",
        V = "V_",
        Vs = "Vs",
        ["\22"] = "^V",
        ["\22s"] = "^V",
        s = "S",
        S = "S_",
        ["\19"] = "^S",
        i = "I",
        ic = "Ic",
        ix = "Ix",
        R = "R",
        Rc = "Rc",
        Rx = "Rx",
        Rv = "Rv",
        Rvc = "Rv",
        Rvx = "Rv",
        c = "C",
        cv = "Ex",
        r = "...",
        rm = "M",
        ["r?"] = "?",
        ["!"] = "!",
        t = "T",
      },
    },
    provider = function(self)
      return "%2("..self.mode_names[self.mode].." %)"
    end,
    update = {
      'WinEnter',
      'WinLeave',
      'ModeChanged',
      -- !!! intended for entering operator-pending mode, but breaks inactive settings
      -- pattern = "*:*",
      -- callback = vim.schedule_wrap(function()
      --   vim.cmd("redrawstatus")
      -- end),
    },
  }

  local heir_mode_modifier = {
    hl = function(self)
      if heir_conditions.is_active() then
        local color = self:mode_color()
        return { fg = 'prefix_text', bg = color, bold = true }
      else
        return { fg = 'prefix_text', bg = 'prefix_inactive', bold = true }
      end
    end,
  }

  heir_mode = heir_utils.insert( heir_mode_modifier, heir_mode )

  local heir_mode_prefix_modifier = {
    -- condition = heir_conditions.is_active(),
    hl = function(self)
      if heir_conditions.is_active() then
        local color = self:mode_color()
        return { fg = color }
      else
        return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
      end
    end,
  }

  local heir_mode_prefix = heir_utils.insert(heir_mode_prefix_modifier, heir_block_prefix)

  heir_mode = heir_utils.insert( heir_mode_prefix, heir_mode )

  local heir_file_path = {
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)
      --self.filename = vim.fn.expand("%:t")
    end,
    hl = function()
      if heir_conditions.is_active() then
        return { fg = 'text', bg = 'bg' }
      else
        return { fg = 'text_inactive', bg = 'bg_inactive' }
      end
    end,
  }

  local heir_file_name = {
    provider = function(self)
      local filename = vim.fn.fnamemodify(self.filename, ":.")
      if filename == "" then return '[No Name]' end
      if not heir_conditions.width_percent_below(#filename, 0.25) then
        filename = vim.fn.pathshorten(filename)
      end
      return ' ' .. filename
    end,
  }

  local heir_file_name_flags = {
    {
      condition = function()
        return vim.bo.modified
      end,
      provider = '+',
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'file_name' }
        end
      end,
    },
    {
      condition = function()
        return not vim.bo.modifiable or vim.bo.readonly
      end,
      provider = '  ',
      hl = { fg = 'file_name_locked' },
    },
  }

  local heir_file_name_modifier = {
    hl = function()
      if vim.bo.modified and heir_conditions.is_active() then
        return { fg = 'file_name', bold = true, force=true }
      end
    end,
  }

  heir_file_path = heir_utils.insert(
    heir_file_path,
    heir_utils.insert(heir_file_name_modifier, heir_file_name),
    { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
  )

  heir_file_path = heir_utils.insert(
    heir_file_path,
    heir_file_name_flags,
    heir_block_suffix
  )

  local heir_help_file_prefix_modifier = {
    hl = function()
      if heir_conditions.is_active() then
        return { fg = 'help', bg = 'statusline' }
      else
        return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
      end
    end
  }

  local heir_help_file_prefix = {
    heir_utils.insert(heir_help_file_prefix_modifier, heir_block_prefix)
  }

  local heir_help_file = {
    { provider = '󰘥 ',
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'prefix_text', bg = 'help' }
        else
          return { fg = 'prefix_text_inactive', bg = 'prefix_inactive' }
        end
      end
    },
    { provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return ' ' .. vim.fn.fnamemodify(filename, ":t")
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'text', bg = 'bg' }
        else
          return { fg = 'text_inactive', bg = 'bg_inactive' }
        end
      end
    },
  }

  heir_help_file = heir_utils.insert(
    heir_help_file_prefix,
    heir_help_file,
    heir_block_suffix
  )

  local heir_terminal_name = {
    { provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
        return " " .. tname
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'text', bg = 'bg' }
        else
          return { fg = 'prefix_text_inactive', bg = 'bg_inactive' }
        end
      end
    },
    heir_block_suffix
  }

  local heir_diagnostics_modifier = {
    condition = heir_conditions.has_diagnostics,
  }
  local heir_diagnostics_prefix_modifier = {
    hl = function()
      if heir_conditions.is_active() then
        return { fg = 'diagnostics', bg = 'statusline' }
      else
        return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
      end
    end
  }

  local heir_diagnostics_spacer = heir_utils.insert(heir_diagnostics_modifier, heir_block_spacer)

  local heir_diagnostics_prefix = {
    heir_utils.insert(heir_diagnostics_prefix_modifier, heir_block_prefix)
  }

  local heir_diagnostics = {
    init = function(self)
      self.error_num = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warn_num = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hint_num = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info_num = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    update = { "DiagnosticChanged", "BufEnter", "WinEnter", 'WinLeave' },
    hl = { fg = 'text_inactive', bg = 'bg_inactive' },

    { provider = ' ',
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'prefix_text', bg = 'diagnostics' }
        else
          return { fg = 'prefix_text_inactive', bg = 'prefix_inactive' }
        end
      end
    },
    { provider = function(self) return self.error_num > 0 and
        (' ' .. self.error_num)
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'ERROR', bg = 'bg' }
        end
      end
    },
    { provider = function(self) return self.warn_num > 0 and
        (' ' .. self.warn_num)
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'WARN', bg = 'bg' }
        end
      end
    },
    { provider = function(self) return self.info_num > 0 and
        (' ' .. self.info_num)
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'INFO', bg = 'bg' }
        end
      end
    },
    { provider = function(self) return self.hint_num > 0 and
        (' ' .. self.hint_num)
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'HINT', bg = 'bg' }
        end
      end
    },
  }

  heir_diagnostics = heir_utils.insert(
    heir_diagnostics_modifier,
    heir_diagnostics_prefix,
    heir_diagnostics,
    heir_block_suffix
  )
  local heir_ruler_prefix_modifier = {
    hl = function(self)
      if heir_conditions.is_active() then
        local color = self:mode_color()
        return { fg = color, bg = 'statusline' }
      else
        return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
      end
    end,
  }

  local heir_ruler_prefix = heir_utils.insert(
    heir_ruler_prefix_modifier,
    heir_block_prefix
  )

  local heir_ruler = {
    { provider = '󰮱 ',
      hl = function(self)
        if heir_conditions.is_active() then
          local color = self:mode_color()
          return { fg = 'prefix_text', bg = color }
        else
          return { fg = 'prefix_text_inactive', bg = 'prefix_inactive' }
        end
      end,
    },
    { provider = ' %(%l/%L%):%c',
    -- { provider = ' %7(%l/%3L%):%2c',
      hl = function(self)
        if heir_conditions.is_active() then
          local color = self:mode_color()
          return { fg = color, bg = 'bg' }
        else
          return { fg = 'text_inactive', bg = 'bg_inactive' }
        end
      end,
    },
  }

  heir_ruler = heir_utils.insert(
    heir_ruler_prefix,
    heir_ruler,
    heir_block_suffix
  )

  local heir_git_modifier = {
    condition = heir_conditions.is_git_repo,
  }

  local heir_git_spacer = heir_utils.insert(
    heir_git_modifier,
    heir_block_spacer
  )

  local heir_git_prefix_modifier = {
    hl = function()
      if heir_conditions.is_active() then
        return { fg = 'git', bg = 'statusline' }
      else
        return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
      end
    end
  }

  local heir_git_prefix = heir_utils.insert(
    heir_git_prefix_modifier,
    heir_block_prefix
  )

  local heir_git = {
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes =
        self.status_dict.added ~= 0
        or self.status_dict.removed ~= 0
        or self.status_dict.changed ~= 0
    end,
    hl = { fg= 'text_inactive', bg  = 'bg_inactive' },

    { provider = ' ',
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'prefix_text', bg = 'git' }
        else
          return { fg = 'prefix_text_inactive', bg = 'prefix_inactive' }
        end
      end,
    },
    { provider = function(self)
        return ' ' .. self.status_dict.head
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'text', bg = 'bg' }
        end
      end,
    },
    { condition = function(self)
        return self.has_changes
      end,
      provider = "(",
      hl = { fg = 'git_parenthese', bg = 'bg' }
    },
    { provider = function(self)
        local count = self.status_dict.added or 0
        return count > 0 and ("+" .. count)
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'git_added', bg = 'bg' }
        end
      end,
    },
    { provider = function(self)
        local count = self.status_dict.removed or 0
        return count > 0 and ("-" .. count)
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'git_removed', bg = 'bg' }
        end
      end,
    },
    { provider = function(self)
        local count = self.status_dict.changed or 0
        return count > 0 and ("~" .. count)
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'git_changed', bg = 'bg' }
        end
      end,
    },
    { condition = function(self)
        return self.has_changes
      end,
      provider = ")",
      hl = { fg = 'git_parenthese', bg = 'bg' }
    },
  }

  heir_git = heir_utils.insert(
    heir_git_modifier,
    heir_git_prefix,
    heir_git,
    heir_block_suffix
  )

  local heir_file_properties_prefix_modifier = {
    hl = function()
      if heir_conditions.is_active() then
        return { fg = 'file_properties', bg = 'statusline' }
      else
        return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
      end
    end
  }
  local heir_file_properties_prefix = heir_utils.insert(
    heir_file_properties_prefix_modifier,
    heir_block_prefix
  )

  local heir_file_properties = {
    hl = { fg = 'text_inactive', bg  = 'bg_inactive' },

    { provider = '󰱽 ',
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'prefix_text', bg = 'file_properties' }
        else
          return { fg = 'prefix_text_inactive', bg = 'prefix_inactive' }
        end
      end,
    },
    { provider = function()
        return ' ' .. string.upper(vim.bo.filetype)
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'text', bg = 'bg' }
        end
      end,
    },
    {
      provider = function()
        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
        if enc ~= 'utf-8' then
          return ' ' .. enc:upper()
        end
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'text', bg = 'bg' }
        end
      end,
    },
    {
      provider = function()
        local fmt = vim.bo.fileformat
        if fmt ~= 'unix' then
          return ' ' .. fmt:upper()
        end
      end,
      hl = function()
        if heir_conditions.is_active() then
          return { fg = 'text', bg = 'bg' }
        end
      end,
    },
  }

  local heir_file_properties_modifier = {
    condition = function()
      local ft = vim.bo.filetype
      local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
      local fmt = vim.bo.fileformat
      if ft == '' and enc == 'utf-8' and fmt == 'unix' then
        return false
      else
        return true
      end
    end,
  }

  local heir_file_properties_spacer = heir_utils.insert(
    heir_file_properties_modifier,
    heir_block_spacer
  )

  heir_file_properties = heir_utils.insert(
    heir_file_properties_modifier,
    heir_file_properties_prefix,
    heir_file_properties,
    heir_block_suffix
  )

  local heir_alignment = {
    provider = '%='
  }

  local heir_default_statusline = {
    heir_mode,
    heir_file_path,
    heir_diagnostics_spacer,
    heir_diagnostics,
    heir_alignment,
    heir_file_properties,
    heir_file_properties_spacer,
    heir_git,
    heir_git_spacer,
    heir_ruler
  }
  local heir_blank_statusline = {
    condition = function()
      return heir_conditions.buffer_matches {
        buftype = { 'NVimTree_1', 'nofile', 'prompt', 'quickfix' },
        filetype = { "^git.*", "fugitive" },
      }
    end,
  }

  local heir_help_statusline = {
    condition = function()
      return heir_conditions.buffer_matches {
        buftype = { 'help' },
      }
    end,
    heir_help_file,
    heir_alignment,
    heir_ruler
  }

  local heir_terminal_statusline = {
    condition = function()
      return heir_conditions.buffer_matches {
        buftype = { 'terminal' },
      }
    end,
    heir_mode,
    heir_terminal_name,
    heir_alignment,
    heir_ruler
  }

  local heir_statusline = {
    fallthrough = false,

    heir_help_statusline,
    heir_terminal_statusline,
    heir_blank_statusline,
    heir_default_statusline,

    static = {
      mode_colors_map = {
        n       = 'mode_normal',
        i       = 'mode_insert',
        v       = 'mode_visual',
        V       = 'mode_visual',
        ["\22"] = 'mode_visual',
        c       = 'mode_command',
        s       = 'mode_select',
        S       = 'mode_select',
        ["\19"] = 'mode_select',
        R       = 'mode_replace',
        r       = 'mode_replace',
        ["!"]   = 'mode_executing',
        t       = 'mode_terminal',
      },
      mode_color = function(self)
        local m = heir_conditions.is_active() and vim.fn.mode() or "n"
        return self.mode_colors_map[m]
      end,

    }
  }

  heirline.setup {
    opts = {
      colors = heir_colors,
    },
    statusline = heir_statusline
  }


end

-- nvim-lualine/lualine.nvim {{{2
-- A blazing fast and easy to configure Neovim statusline written in Lua
local lualine_loaded, lualine = pcall(require, 'lualine')
if lualine_loaded then

  lualine.setup {
    options = {
      icons_enabled = false,
      -- theme = auto,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { { 'mode', separator = { left = '', right = '' } } },
      lualine_b = { 'branch', { 'diagnostics', sources = { 'nvim_lsp' } } },
      lualine_c = { 'filename' },
      --lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_x = { 'diff', 'spaces', 'encoding'},
      lualine_y = { 'filetype' },
      lualine_z = { { 'location', separator = { left = '', right = '' } } },
      --lualine_z = { progress },
      },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        { 'diagnostics', sources = { 'nvim_lsp' } },
        function()
          return "%="
        end,
        "filename"
      },
      --lualine_c = { filename },
      lualine_x = { { 'location', separator = { left = '', right = '' } } },
      lualine_y = {},
      --lualine_z = {},
    },
    tabline = {},
    extensions = {},
  }

end

-- ibhagwan/fzf-lua {{{2
-- Does anything need to be said?
local fzf_lua_loaded, fzf_lua = pcall(require, 'fzf-lua')
if fzf_lua_loaded then
  fzf_lua.setup {
    hls = {
      border = "FloatBorder",
      preview_border = "FloatBorder",
      header_text = "Comment",
      header_bind = "Comment",
    },
    actions = {
      files = {
        ["default"] = fzf_lua.actions.file_edit,
        ["ctrl-v"] = fzf_lua.actions.file_split,
        ["ctrl-s"] = fzf_lua.actions.file_vsplit,
        ["alt-q"] = fzf_lua.actions.file_sel_to_qf,
      },
    },
    fzf_colors = {
      --["bg"] = { "bg", "Normal" },
      --["bg+"] = { "bg", "Normal" },
      ["fg"] = { "fg", "Comment" },
      ["fg+"] = { "fg", "Normal" },
      ["hl"] = { "fg", "Special" },
      ["hl+"] = { "fg", "Special" },
      ["info"] = { "fg", "PreProc" },
      ["prompt"] = { "fg", "Comment" },
      ["pointer"] = { "fg", "Special" },
      ["marker"] = { "fg", "Keyword" },
      ["spinner"] = { "fg", "Label" },
      ["header"] = { "fg", "Comment" },
      ["separator"] = { "fg", "FloatBorder" },
      ["scrollbar"] = { "fg", "FloatBorder" },
    },
    winopts = {
      height = 0.7,
      width = 0.8,
      row = 0.5,
      col = 0.5,
      preview = {
        layout = "vertical",
        vertical = "up:44%",
        scrollbar = false,
      },
    },
  }

  local fzf_map = function(keys, type, desc)
    local command = function()
      if type == "" then
        require("fzf-lua").builtin({
          winopts = {
            height = 0.2,
            width = 40,
            row = 0.4,
            col = 0.48,
          },
        })
      else
        require("fzf-lua")[type]({
          file_icons = false,
          git_icons = false,
          color_icons = false,
        })
      end
    end
    vim.keymap.set("n", keys, command, { desc = desc })
  end

  fzf_map("<leader>fz", "", "FZF")
  fzf_map("<leader>ff", "files", "Files")
  fzf_map("<leader>fh", "help_tags", "Help")
  fzf_map("<leader>fb", "buffers", "Buffers")
  fzf_map("<leader>fg", "live_grep", "Grep Word")
  fzf_map("<leader>fv", "grep_visual", "Grep Visual")
  fzf_map("<leader>fr", "oldfiles", "Recent files")
  fzf_map("<leader>fc", "grep_cword", "Current Word")
  fzf_map("<leader>fd", "diagnostics_document", "Diagnostics")

  --lsp
  fzf_map("<leader>lr", "lsp_references", "LSP References")
  fzf_map("<leader>ld", "lsp_definitions", "LSP Definitions")
  fzf_map("<leader>lI", "lsp_implementations", "LSP Implementations")
  fzf_map("<leader>lt", "lsp_typedefs", "LSP Type Definitions")
end

-- folke/which-key.nvim {{{2 
-- helps you remember your Neovim keymaps, showing keybindings in a popup
local wk_enabled, wk = pcall(require, 'which-key')
if wk_enabled then
  wk.setup {
    delay = 1500,
    keys = {
      scroll_down = "<a-d>", -- binding to scroll down inside the popup
      scroll_up = "<a-u>", -- binding to scroll up inside the popup
    },
  }
  wk.add {
    { 'gj', desc = 'Scroll Down (250)' },
    { 'gJ', desc = 'Scroll Down (450)' },
    { 'gk', desc = 'Scroll Up (250)' },
    { 'gK', desc = 'Scroll Up (450)' },
    { '<leader>fss', desc = 'Possession List' },
    { '<leader>fsn', desc = 'Possession New' },
    { '<leader>fsu', desc = 'Possession Update' },
    { '<leader>fsd', desc = 'Possession Delete' },
    { '<leader>ff', desc = 'Telescope Files' },
    { '<leader>fg', desc = 'Telescope Grep' },
    { '<leader>fb', desc = 'Telescope Buffers' },
    { '<leader>fh', desc = 'Telescope Help' },
  }
end

-- williamboman/mason.nvim {{{2
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.
local mason_loaded, mason = pcall(require, 'mason')
if mason_loaded then

  local lspconfig = require('lspconfig')
  local mason_lspconfig = require('mason-lspconfig')
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  local select_opts = {behavior = cmp.SelectBehavior.Select}
  local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

  mason.setup {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  }

  mason_lspconfig.setup {
    ensure_installed = { 'lua_ls', 'efm' },
    automatic_installation = true,
  }

  mason_lspconfig.setup_handlers {
    function(server)
      lspconfig[server].setup {
        capabilities = lsp_capabilities,
      }
    end,
    ['lua_ls'] = function()
      lspconfig.lua_ls.setup {
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
              }
            }
          }
        }
      }
    end,
    [ 'efm' ] = function()
      lspconfig.efm.setup {
        init_options = {documentFormatting = true},
        settings = {
          rootMarkers = {".git/"},
          languages = {
            sh = {
              { formatCommand = 'shfmt -ci -s -bn' },
              { formatStdin = true },
              { lintCommand = 'shellcheck -f gcc -x' },
              { lintSource = 'shellcheck'},
              { lintFormats = { '%f:%l:%c: %trror: %m',
                               '%f:%l:%c: %tarning: %m',
                               '%f:%l:%c: %tote: %m' } },
              { LintIgnoreExitCode = true },
            }
          }
        }
      }
    end,
  }

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
      -- Move to the previous diagnostic
      bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
      -- Move to the next diagnostic
      bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
    end
  })

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
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
      documentation = cmp.config.window.bordered()
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
      ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
      ['<Down>'] = cmp.mapping.select_next_item(select_opts),

      ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
      ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),

      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-y>'] = cmp.mapping.confirm({select = true}),
      ['<CR>'] = cmp.mapping.confirm({select = false}),

      ['<C-f>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, {'i', 's'}),

      ['<C-b>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {'i', 's'}),
      ['<Tab>'] = cmp.mapping(function(fallback)
        local col = vim.fn.col('.') - 1

        if cmp.visible() and has_words_before() then
          cmp.select_next_item(select_opts)
        elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          fallback()
        else
          cmp.complete()
        end
      end, {'i', 's'}),

      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item(select_opts)
        else
          fallback()
        end
      end, {'i', 's'}),
    },
  }
end

-- j-hui/fidget.nvim {{{2
-- extensible UI for Neovim notifications and LSP progress messages
local fidget_loaded, fidget = pcall(require, 'fidget')
if fidget_loaded then
  fidget.setup {
    -- Options related to LSP progress subsystem
    progress = {
      poll_rate = 0,                -- How and when to poll for progress messages
      suppress_on_insert = false,   -- Suppress new messages while in insert mode
      ignore_done_already = false,  -- Ignore new tasks that are already complete
      ignore_empty_message = false, -- Ignore new tasks that don't contain a message
      clear_on_detach =             -- Clear notification group when LSP server detaches
        function(client_id)
          local client = vim.lsp.get_client_by_id(client_id)
          return client and client.name or nil
        end,
      notification_group =          -- How to get a progress message's notification group key
        function(msg) return msg.lsp_client.name end,
      ignore = {},                  -- List of LSP servers to ignore

      -- Options related to how LSP progress messages are displayed as notifications
      display = {
        render_limit = 16,          -- How many LSP messages to show at once
        done_ttl = 4,               -- How long a message should persist after completion
        done_icon = "  ",          -- Icon shown when all LSP progress tasks are complete
        done_style = "Constant",    -- Highlight group for completed LSP tasks
        progress_ttl = math.huge,   -- How long a message should persist when in progress
        progress_icon =             -- Icon shown when LSP progress tasks are in progress
          { pattern = "dots", period = 1 },
        progress_style =            -- Highlight group for in-progress LSP tasks
          "WarningMsg",
        group_style = "Title",      -- Highlight group for group name (LSP server name)
        icon_style = "Question",    -- Highlight group for group icons
        priority = 30,              -- Ordering priority for LSP notification group
        skip_history = true,        -- Whether progress notifications should be omitted from history
        format_message =            -- How to format a progress message
          require("fidget.progress.display").default_format_message,
        format_annote =             -- How to format a progress annotation
          function(msg) return msg.title end,
        format_group_name =         -- How to format a progress notification group's name
          function(group) return tostring(group) end,
        overrides = {               -- Override options from the default notification config
          rust_analyzer = { name = "rust-analyzer" },
        },
      },

      -- Options related to Neovim's built-in LSP client
      lsp = {
        progress_ringbuf_size = 0,  -- Configure the nvim's LSP progress ring buffer size
        log_handler = false,        -- Log `$/progress` handler invocations (for debugging)
      },
    },

    -- Options related to notification subsystem
    notification = {
      poll_rate = 10,               -- How frequently to update and render notifications
      filter = vim.log.levels.INFO, -- Minimum notifications level
      history_size = 128,           -- Number of removed messages to retain in history
      override_vim_notify = true,   -- Automatically override vim.notify() with Fidget
      configs =                     -- How to configure notification groups when instantiated
        { default = require("fidget.notification").default_config },
      redirect =                    -- Conditionally redirect notifications to another backend
        function(msg, level, opts)
          if opts and opts.on_open then
            return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
          end
        end,

      -- Options related to how notifications are rendered as text
      view = {
        stack_upwards = true,       -- Display notification items from bottom to top
        icon_separator = " ",       -- Separator between group name and icon
        group_separator = "---",    -- Separator between notification groups
        group_separator_hl =        -- Highlight group used for group separator
          "Comment",
        render_message =            -- How to render notification messages
          function(msg, cnt)
            return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
          end,
      },

      -- Options related to the notification window and buffer
      window = {
        normal_hl = "Comment",      -- Base highlight group in the notification window
        winblend = 100,             -- Background color opacity in the notification window
        border = "none",            -- Border around the notification window
        zindex = 45,                -- Stacking priority of the notification window
        max_width = 0,              -- Maximum width of the notification window
        max_height = 0,             -- Maximum height of the notification window
        x_padding = 1,              -- Padding from right edge of window boundary
        y_padding = 1,              -- Padding from bottom edge of window boundary
        align = "bottom",           -- How to align the notification window
        relative = "editor",        -- What the notification window position is relative to
      },
    },

    -- Options related to integrating with other plugins
    integration = {
      ["nvim-tree"] = {
        enable = true,              -- Integrate with nvim-tree/nvim-tree.lua (if installed)
      },
      ["xcodebuild-nvim"] = {
        enable = true,              -- Integrate with wojciech-kulik/xcodebuild.nvim (if installed)
      },
    },

    -- Options related to logging
    logger = {
      level = vim.log.levels.WARN,  -- Minimum logging level
      max_size = 10000,             -- Maximum log file size, in KB
      float_precision = 0.01,       -- Limit the number of decimals displayed for floats
      path =                        -- Where Fidget writes its logs to
        string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
    },
  }
end

-- gennaro-tedesco/nvim-possession {{{2
-- no-nonsense session manager
local possession_loaded, possession = pcall(require, 'nvim-possession')
if possession_loaded then
  possession.setup({
    sessions = {
      --sessions_path =     '' -- folder to look for sessions, must be a valid existing path
      --sessions_variable = '' -- defines vim.g[sessions_variable] when a session is loaded
      --sessions_icon =     '' -- string: shows icon both in the prompt and in the statusline
      --sessions_prompt =   '' -- fzf prompt string
    },
    autoload = true,    -- whether to autoload sessions in the cwd at startup
    autosave = true,    -- whether to autosave loaded sessions before quitting
    autoswitch = {
      enable = true,     -- whether to enable autoswitch
      exclude_ft = {},  -- list of filetypes to exclude from autoswitch
    },

    save_hook = function()
                  vim.cmd([[ScopeSaveState]]) -- Scope.nvim saving
                end,
    post_hook = function()
                  vim.cmd([[ScopeLoadState]]) -- Scope.nvim loading
                end,
                      -- callback, function to execute after loading a session
                      -- useful to restore file trees, file managers or terminals
                      -- function()
                      --   require('FTerm').open()
                      --   require('nvim-tree').toggle(false, true)
                      -- end
  fzf_winopts = {
    -- any valid fzf-lua winopts options, for instance
    width = 0.5,
    preview = {
        vertical = "right:30%"
    },
  },
})

end

-- utils {{{1

-- expand or minimize current buffer in a more natural direction (tmux-like)
-- ':resize <+-n>' or ':vert resize <+-n>' increases or decreasese current
-- window horizontally or vertically. When mapped to '<leader><arrow>' this
-- can get confusing as left might actually be right, etc
-- the below can be mapped to arrows and will work similar to the tmux binds
-- map to: "<cmd>lua require'utils'.resize(false, -5)<CR>"
local function relative_resize(vertical, margin)
  local cur_win = vim.api.nvim_get_current_win()
  -- go (possibly) right
  vim.cmd(string.format('wincmd %s', vertical and 'l' or 'j'))
  local new_win = vim.api.nvim_get_current_win()
  -- determine direction cond on increase and existing right-hand buffer
  local not_last = not (cur_win == new_win)
  local sign = margin > 0
  -- go to previous window if required otherwise flip sign
  if not_last == true then
    vim.cmd [[wincmd p]]

  else
    sign = not sign
  end

  local sign_char = sign and '+' or '-'
  local dir = vertical and 'vertical ' or ''
  local cmd = dir .. 'resize ' .. sign_char .. math.abs(margin) .. '<CR>'
  vim.cmd(cmd)
end

-- sudo execution
local function sudo_exec(cmd, print_output)
  vim.fn.inputsave()
  local password = vim.fn.inputsecret("Password: ")
  vim.fn.inputrestore()
  if not password or #password == 0 then
      vim.notify('Invalid password, sudo aborted', vim.log.levels.ERROR)
      return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    print("\r\n")
    error(out)
    return false
  end
  if print_output then print("\r\n", out) end
  return true
end

-- sudo save 
local function sudo_write(tmpfile, filepath)
  if not tmpfile then tmpfile = vim.fn.tempname() end
  if not filepath then filepath = vim.fn.expand("%") end
  if not filepath or #filepath == 0 then
    error("E32: No file name")
    return
  end
  -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1M` and `bs=1m` are non-POSIX
  local cmd = string.format("dd if=%s of=%s bs=1048576",
    vim.fn.shellescape(tmpfile),
    vim.fn.shellescape(filepath))
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec2(string.format("write! %s", tmpfile), { output = false })
  if sudo_exec(cmd) then
    print(string.format('\r\n"%s" written', filepath))
    vim.cmd("e!")
  end
  vim.fn.delete(tmpfile)
end

-- auto commands {{{1

local aucmd = vim.api.nvim_create_autocmd

local function augroup(name, fnc)
  fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

augroup('NewlineNoAutoComments', function()
  aucmd("FileType", {
    pattern = '*',
    command = "setlocal formatoptions-=o"
  })
end)

-- remove search highlights while in insert mode
augroup('ToggleSearchHL', function(g)
  aucmd("InsertEnter",
  {
    group = g,
    pattern = '*',
    command = ':nohl | redraw'
  })
end)

-- hide line numbers  in terminal mode
augroup('TermOptions', function(g)
  aucmd("TermOpen",
  {
    group = g,
    pattern = '*',
    command = 'setlocal listchars= nonumber norelativenumber | exec "normal! i"'
  })
end)

-- different folding methods for different files 
augroup('FoldingMethods', function()
  aucmd( {"BufEnter", "BufWinEnter"} ,
  {
    pattern = {'init.lua', '.zshrc'},
    command = 'setlocal foldmethod=marker',
  })
end)

-- key mapping {{{1

local map = vim.keymap.set

-- convenience mappings {{{2

map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')


-- <ctrl-s> to Save
map({ 'n', 'v', 'i'}, '<C-S>', '<C-c>:update<cr>', { silent = true })

-- open Nvim Tree
map("n", "<leader>ft", ":NvimTreeToggle<CR>")

-- turn off search matches with double-<Esc>
map('n', '<Esc><Esc>', '<Esc>:nohlsearch<CR>', { silent = true })

-- toggle display of `listchars`
map('n', '<leader>\'', '<Esc>:set list!<CR>',   { silent = true })

-- toggle colored column at 81
map('n', '<leader>|',
    ':execute "set colorcolumn=" . (&colorcolumn == "" ? "81" : "")<CR>',
    { silent = true })

-- Change current working dir (:pwd) to curent file's folder
--map('n', '<leader>%', '<Esc>:lua require"utils".set_cwd()<CR>', { silent = true })

-- Map <leader>o & <leader>O to newline without insert mode
map('n', '<leader>o',
    ':<C-u>call append(line("."), repeat([""], v:count1))<CR>',
    { silent = true })
map('n', '<leader>O',
    ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
    { silent = true })


--- w!! to save with sudo
map('c', 'w!!', function() sudo_write() end, { silent = true })

-- Beginning and end of line in `:` command mode
map('c', '<C-a>', '<home>', {})
map('c', '<C-e>', '<end>' , {})


-- not sure this is needed anymore
-- Arrows in command line mode (':') menus
--map('c', '<down>', '(wildmenumode() ? "\\<C-n>" : "\\<down>")', { expr = true })
--map('c', '<up>',   '(wildmenumode() ? "\\<C-p>" : "\\<up>")',   { expr = true })
--for k, v in pairs({ ['<down>'] = '<C-n>', ['<up>'] = '<C-p>' }) do
--  map('c', k, function()
--    return vim.fn.wildmenumode() and v or k
--  end, {expr=true})
--end

-- terminal mappings {{{2
--map('t', '<M-[>', [[<C-\><C-n>]],      {})
--map('t', '<C-w>', [[<C-\><C-n><C-w>]], {})

map('t', '<A-r>', [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })


-- tmux like directional window resizes
--map('n', '<leader><Up>',    function() relative_resize(false, -5) end, { silent = true })
--map('n', '<leader><Down>',  function() relative_resize(false,  5) end, { silent = true })
--map('n', '<leader><Left>',  function() relative_resize(true,  -5) end, { silent = true })
--map('n', '<leader><Right>', function() relative_resize(true,   5) end, { silent = true })
--map('n', '<leader>=', '<C-w>=', { silent = true })
-- navigation {{{2

-- navigate buffers {{{3
map('n', '<leader>,',         ':tabprevious<CR>', {})
map('n', '<leader>.',         ':tabnext<CR>',     {})
map('n', '<leader>tf',         ':tabfirst<CR>',    {})
map('n', '<leader>tl',         ':tablast<CR>',     {})
map('n', '<Leader>tn', ':tabnew<CR>',      {})
map('n', '<Leader>tc', ':tabclose<CR>',    {})
map('n', '<Leader>to', ':tabonly<CR>',     {})

map('n', '[b', ':bprevious<CR>',      {})
map('n', ']b', ':bnext<CR>',          {})
map('n', '[B', ':bfirst<CR>',         {})
map('n', ']B', ':blast<CR>',          {})

-- map("n", "<Tab>", ":bnext<CR>",       {})
-- map("n", "<S-Tab>", ":bprevious<CR>", {})

map("n", "<A-.>", ":bnext<CR>",       {})
map("n", "<A-,>", ":bprevious<CR>",   {})

map("n", "<A->>", ":BufferMoveNext<CR>", {})
map("n", "<A-<>", ":BufferMovePrevious<CR>", {})

-- close buffer without loosing the opened window
map("n", "<C-c>", ":BufferClose<CR>", { silent = true })

-- navigate tabs {{{3

-- Jump to first tab & close all other tabs. Helpful after running Git difftool.
map('n', '<Leader>tO', ':tabfirst<CR>:tabonly<CR>', {})
-- tmux <c-meta>z like
--map('n', '<Leader>tz',  "<cmd>lua require'utils'.tabZ()<CR>", {})

-- split navigation {{{3
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("t", "<C-h>", "<C-\\><C-N><C-w>h")
map("t", "<C-j>", "<C-\\><C-N><C-w>j")
map("t", "<C-k>", "<C-\\><C-N><C-w>k")
map("t", "<C-l>", "<C-\\><C-N><C-w>l")

map("i", "<C-h>", "<C-\\><C-N><C-w>h")
map("i", "<C-j>", "<C-\\><C-N><C-w>j")
map("i", "<C-k>", "<C-\\><C-N><C-w>k")
map("i", "<C-l>", "<C-\\><C-N><C-w>l")

-- split resize
map("n", "<A-k>", ":resize -2<CR>", {silent = true})
map("n", "<A-j>", ":resize +2<CR>", {silent = true})
map("n", "<A-h>", ":vertical resize -2<CR>")
map("n", "<A-l>", ":vertical resize +2<CR>")

map("t", "<A-k>", "<C-\\><C-N>:resize -2<CR>i", {silent = true})
map("t", "<A-j>", "<C-\\><C-N>:resize +2<CR>i", {silent = true})
map("t", "<A-h>", "<C-\\><C-N>:vertical resize -2<CR>i")
map("t", "<A-l>", "<C-\\><C-N>:vertical resize +2<CR>i")

map("i", "<A-k>", "<C-\\><C-N>:resize -2<CR>i", {silent = true})
map("i", "<A-j>", "<C-\\><C-N>:resize +2<CR>i", {silent = true})
map("i", "<A-h>", "<C-\\><C-N>:vertical resize -2<CR>i")
map("i", "<A-l>", "<C-\\><C-N>:vertical resize +2<CR>i")

-- quickfix list mappings {{{3
--map('n', '<leader>q', "<cmd>lua require'utils'.toggle_qf('q')<CR>", {})
map('n', '[q', ':cprevious<CR>',      {})
map('n', ']q', ':cnext<CR>',          {})
map('n', '[Q', ':cfirst<CR>',         {})
map('n', ']Q', ':clast<CR>',          {})

-- location list mappings {{{3
--map('n', '<leader>Q', "<cmd>lua require'utils'.toggle_qf('l')<CR>", {})
map('n', '[l', ':lprevious<CR>',      {})
map('n', ']l', ':lnext<CR>',          {})
map('n', '[L', ':lfirst<CR>',         {})
map('n', ']L', ':llast<CR>',          {})

-- shortcut to view :messages
map({'n', 'v'}, '<leader>m', '<cmd>messages<CR>',  {})
map({'n', 'v'}, '<leader>M', '<cmd>mes clear|echo "cleared :messages"<CR>', {})

-- plugin mappings {{{2

if possession_loaded then
  map('n', '<leader>fss', function() possession.list() end)
  map('n', '<leader>fsn', function() possession.new() end)
  map('n', '<leader>fsu', function() possession.update() end)
  map('n', '<leader>fsd', function() possession.delete() end)
end

if neoscroll_loaded then
  local keymap = {
    ['gk'] = function() neoscroll.ctrl_u({ duration = 250 }) end;
    ['gj'] = function() neoscroll.ctrl_d({ duration = 250 }) end;
    ['gK'] = function() neoscroll.ctrl_b({ duration = 450 }) end;
    ['gJ'] = function() neoscroll.ctrl_f({ duration = 450 }) end;
    --["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor=false; duration = 100 }) end;
    --["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor=false; duration = 100 }) end;
    --["zt"]    = function() neoscroll.zt({ half_win_duration = 250 }) end;
    --["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end;
    --["zb"]    = function() neoscroll.zb({ half_win_duration = 250 }) end;
  }
  local modes = { 'n', 'v', 'x' }
  for key, func in pairs(keymap) do
    map(modes, key, func)
  end
end

if hop_loaded then
  map({'n', 'v'}, '<leader>hh', '<cmd>HopChar1<CR>',{})
  map({'n', 'v'}, '<leader>hc', '<cmd>HopCurrentline<CR>',{})
  map({'n', 'v'}, '<leader>hl', '<cmd>HopLine<CR>',{})
  map({'n', 'v'}, '<leader>hs', '<cmd>HopLineStart<CR>',{})
  map({'n', 'v'}, '<leader>hp', '<cmd>HopPattern<CR>',{})
end

if telescope_loaded then
  local builtin = require('telescope.builtin')
  map('n', '<leader>ff', builtin.find_files, {})
  map('n', '<leader>fg', builtin.live_grep, {})
  map('n', '<leader>fb', builtin.buffers, {})
  map('n', '<leader>fh', builtin.help_tags, {})
end

-- <leader>v|<leader>s act as <cmd-v>|<cmd-s>
-- <leader>p|P paste from yank register (0)
map({'n', 'v'}, '<leader>v', '"+p',   {})
map({'n', 'v'}, '<leader>V', '"+P',   {})
map({'n', 'v'}, '<leader>s', '"*p',   {})
map({'n', 'v'}, '<leader>S', '"*P',   {})
map({'n', 'v'}, '<leader>p', '"0p',   {})
map({'n', 'v'}, '<leader>P', '"0P',   {})
-- copy current file path to the clipboard
map({'n', 'v'}, '<leader>y', '<cmd>let @+=@0<CR>', {})

-- overloads for 'd|c' that don't pollute the unnamed registers
map('n', '<leader>D',  '"_D',         {})
map('n', '<leader>C',  '"_C',         {})
map({'n', 'v'}, '<leader>c',  '"_c',  {})

-- keep visual selection when (de)indenting
map('v', '<', '<gv', {})
map('v', '>', '>gv', {})

-- Move selected lines up/down in visual mode
--map('x', 'K', ":move '<-2<CR>gv=gv", {})
--map('x', 'J', ":move '>+1<CR>gv=gv", {})

-- Select last pasted/yanked text
map('n', 'g<C-v>', '`[v`]', {})

-- Keep matches center screen when cycling with n|N
map('n', 'n', 'nzzzv', {})
map('n', 'N', 'Nzzzv', {})

-- Break undo chain on punctuation so we can
-- use 'u' to undo sections of an edit
-- DISABLED, ALL KINDS OF ODDITIES
--[[ for _, c in ipairs({',', '.', '!', '?', ';'}) do
   map('i', c, c .. "<C-g>u", {})
end --]]

-- any jump over 5 modifies the jumplist
-- so we can use <C-o> <C-i> to jump back and forth
--for _, c in ipairs({'j', 'k'}) do
--  map('n', c, ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c),
--    { expr = true, silent = true})
--end

-- move along visual lines, not numbered ones
-- without interferring with {count}<down|up>
--for _, m in ipairs({'n', 'v'}) do
--  for _, c in ipairs({ {'<up>','k'}, {'<down>','j'} }) do
--    map(m, c[1], ([[v:count == 0 ? 'g%s' : '%s']]):format(c[2], c[2]),
--        { expr = true, silent = true})
--  end
--end

-- Search and Replace {{{3

-- 'c.' for word, 'c>' for WORD
-- 'c.' in visual mode for selection
--map('n', 'c.', [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], {})
--map('n', 'c>', [[:%s/\V<C-r><C-a>//g<Left><Left>]], {})
--map('x', 'c.', [[:<C-u>%s/\V<C-r>=luaeval("require'utils'.get_visual_selection(true)")<CR>//g<Left><Left>]], {})


-- Use operator pending mode to visually select entire buffer, e.g.
--    d<A-a> = delete entire buffer
--    y<A-a> = yank entire buffer
--    v<A-a> = visual select entire buffer
--map('o', '<A-a>', ':<C-U>normal! mzggVG<CR>`z')
--map('x', '<A-a>', ':<C-U>normal! ggVG<CR>')

-- LuaSnip keybindings
--vim.keymap.set({"i"}, "<C-K>", function() require("luasnip").expand() end, {silent = true})
--vim.keymap.set({"i", "s"}, "<C-L>", function() require("luasnip").jump( 1) end, {silent = true})
--vim.keymap.set({"i", "s"}, "<C-J>", function() require("luasnip").jump(-1) end, {silent = true})
--vim.keymap.set({"i", "s"}, "<C-E>", function()
--	if require("luasnip").choice_active() then
--		require("luasnip").change_choice(1)
--	end
--end, {silent = true})

-- fugitive shortcuts for yadm
--local yadm_repo = "$HOME/dots/yadm-repo"

-- auto-complete for our custom fugitive Yadm command
-- https://github.com/tpope/vim-fugitive/issues/1981#issuecomment-1113825991
--vim.cmd(([[
--  function! YadmComplete(A, L, P) abort
--    return fugitive#Complete(a:A, a:L, a:P, {'git_dir': expand("%s")})
--  endfunction
--]]):format(yadm_repo))

--vim.cmd(([[command! -bang -nargs=? -range=-1 -complete=customlist,YadmComplete Yadm exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, { 'git_dir': expand("%s") })]]):format(yadm_repo))

--local function fugitive_command(nargs, cmd_name, cmd_fugitive, cmd_comp)
--  vim.api.nvim_create_user_command(cmd_name,
--    function(t)
--      local bufnr = vim.api.nvim_get_current_buf()
--      local buf_git_dir = vim.b.git_dir
--      vim.b.git_dir = vim.fn.expand(yadm_repo)
--      vim.cmd(cmd_fugitive .. " " .. t.args)
--      -- after the fugitive window switch we must explicitly
--      -- use the buffer num to restore the original 'git_dir'
--      vim.b[bufnr].git_dir = buf_git_dir
--    end,
--    {
--      nargs = nargs,
--      complete = cmd_comp and string.format("customlist,%s", cmd_comp) or nil,
--    }
--  )
--end

-- fugitive_command("?", "Yadm",        "Git",          "fugitive#Complete")
--fugitive_command("?", "Yit",         "Git",          "YadmComplete")
--fugitive_command("*", "Yread",       "Gread",        "fugitive#ReadComplete")
--fugitive_command("*", "Yedit",       "Gedit",        "fugitive#EditComplete")
--fugitive_command("*", "Ywrite",      "Gwrite",       "fugitive#EditComplete")
--fugitive_command("*", "Ydiffsplit",  "Gdiffsplit",   "fugitive#EditComplete")
--fugitive_command("*", "Yhdiffsplit", "Ghdiffsplit",  "fugitive#EditComplete")
--fugitive_command("*", "Yvdiffsplit", "Gvdiffsplit",  "fugitive#EditComplete")
--fugitive_command(1,   "YMove",       "GMove",        "fugitive#CompleteObject")
--fugitive_command(1,   "YRename",     "GRename",      "fugitive#RenameComplete")
--fugitive_command(0,   "YRemove",     "GRemove")
--fugitive_command(0,   "YUnlink",     "GUnlink")
--fugitive_command(0,   "YDelete",     "GDelete")
