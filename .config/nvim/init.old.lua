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

-- DO NOT NEED ANY OF THIS, CRUTCH THAT POULLUTES REGISTERS
-- vim clipboard copies to system clipboard
-- unnamed     = use the * register (cmd-s paste in our term)
-- unnamedplus = use the + register (cmd-v paste in our term)
-- autoselect
o.clipboard         = 'unnamedplus'

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

-- Characters to display on ':set list',explore glyphs using:
-- `xfd -fa "InputMonoNerdFont:style:Regular"` or
-- `xfd -fn "-misc-fixed-medium-r-semicondensed-*-13-*-*-*-*-*-iso10646-1"`
-- input special chars with the sequence <C-v-u> followed by the hex code
o.list      = false
o.listchars = {
  tab       = '→ '  ,
  eol       = '↲'   ,
  nbsp      = '␣'   ,
  lead      = '␣'   ,
  space     = '␣'   ,
  trail     = '•'   ,
  extends   = '⟩'   ,
  precedes  = '⟨'   ,
}
o.showbreak = '↪ '

-- show menu even for one item do not auto select/insert
o.completeopt       = { 'noinsert' , 'menuone' , 'noselect' }
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

o.foldenable        = true      -- enable folding
o.foldlevelstart    = 10        -- open most folds by default
o.foldnestmax       = 10        -- 10 nested fold max
o.foldmethod        = 'marker'  -- fold based on indent level

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

vim.api.nvim_command('set rtp-=/usr/share/vim/vimfiles') -- do not load system fzf.vim (Arch, etc.)

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- load plugins with lazy.nvim {{{1
require("lazy").setup {
  spec = {
    { "nvim-lua/plenary.nvim" },
    { "gennaro-tedesco/nvim-possession",
      lazy = false,
      dependencies = {
        { "tiagovla/scope.nvim",
          lazy = false,
          config = true,
        },
        { "ibhagwan/fzf-lua" },
      },
    },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-tree/nvim-tree.lua", version = "*", lazy = false },
    { "nvim-treesitter/nvim-treesitter" },
    { "EdenEast/nightfox.nvim" },
    { "tiagovla/scope.nvim" },
    { "romgrk/barbar.nvim" },
    { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },
    { "nvim-lualine/lualine.nvim" },
    { "karb94/neoscroll.nvim" },
    { "ibhagwan/fzf-lua" },
--    { "numToStr/Comment.nvim" },

    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
--    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},

        { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
        { "saadparwaiz1/cmp_luasnip" },
--      dependencies = {
        { "neovim/nvim-lspconfig" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" },
 --     },
  },

--},
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "nightfox" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
}

-- plugin setup {{{1

-- nvim-tree/nvim-tree.lua {{{2
-- A File Explorer For Neovim Written In Lua
local nvim_tree_loaded, nvim_tree = pcall(require, 'nvim-tree')
if nvim_tree_loaded then
  nvim_tree.setup()
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
        scope_incremental = '',
      },
    },
  }
end

-- EdenEast/nightfox.nvim {{{2
-- Theme with support for lsp, treesitter and a variety of plugins.
local nightfox_loaded, nightfox = pcall(require, 'nightfox')
if nightfox_loaded then
  nightfox.setup {
    options = {
      transparent = false,     -- Disable setting background
      terminal_colors = true,  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
      dim_inactive = true,     -- Non focused panes set to alternative background
      --barbar = true,
      styles = {               -- Style to be applied to different syntax groups
      comments = "italic",     -- Value is any valid attr-list value `:help attr-list`
      keywords = "bold",
      types = "italic,bold",
      },
      modules = {              -- List of various plugins and additional options
      -- ...
      },
    },
    palettes = {},
    specs = {},
    groups = {
      carbonfox = {
        BufferCurrent = { bg = "#777777", fg = "#ffffff" },
        BufferCurrentIndex = { bg = "#777777", fg = "#ffffff" },
        BufferCurrentMod = { bg = "#777777", fg = "#ffffff" },
        BufferCurrentSign = { bg = "#777777", fg = "#1c1c1c" },
        BufferCurrentTarget = { bg = "#777777", fg = "#ffffff" },
        BufferVisible = { bg = "#444444", fg = "#bbbbbb" },
        BufferVisibleIndex = { bg = "#444444", fg = "#bbbbbb" },
        BufferVisibleMod = { bg = "#444444", fg = "#bbbbbb" },
        BufferVisibleSign = { bg = "#444444", fg = "#1c1c1c" },
        BufferVisibleTarget = { bg = "#444444", fg = "#bbbbbb" },
        BufferInactive = { bg = "#444444", fg = "#bbbbbb" },
        BufferInactiveIndex = { bg = "#444444", fg = "#bbbbbb" },
        BufferInactiveMod = { bg = "#444444", fg = "#bbbbbb" },
        BufferInactiveSign = { bg = "#444444", fg = "#1c1c1c" },
        BufferInactiveTarget = { bg = "#444444", fg = "#bbbbbb" },
        BufferTabpage = { bg = "#1c1c1c", fg = "#ffffff" },
        BufferTabpageFill = { bg = "#1c1c1c", fg = "#1c1c1c" },
        Normal = { bg = "#000000" },
      },
    },
  }
  vim.cmd("colorscheme carbonfox")
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

-- nvim-lualine/lualine.nvim {{{2
-- A blazing fast and easy to configure Neovim statusline written in Lua
local lualine_loaded, lualine = pcall(require, 'lualine')
if lualine_loaded then
  local hide_in_width = function()
	  return vim.fn.winwidth(0) > 80
  end

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = false,
    update_in_insert = false,
    always_visible = true,
  }

  local diff = {
  	"diff",
  	colored = false,
  	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = hide_in_width
  }

  local mode = {
    "mode",
    fmt = function(str)
    return "-- " .. str .. " --"
    end,
  }

  local filetype = {
    "filetype",
    icons_enabled = false,
    icon = nil,
  }

  local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
  }

  local location = {
    "location",
    padding = 0,
  }

  -- cool function for progress
  local progress = function()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
	  return chars[index]
  end

  local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end

  local custom_powerline = require'lualine.themes.powerline'

  custom_powerline.normal.a.bg = '#ffffff'
  custom_powerline.normal.a.fg = '#000000'
  custom_powerline.normal.b.bg = '#444444'
  custom_powerline.normal.b.fg = '#ffffff'
  custom_powerline.normal.c.bg = '#1c1c1c'
  custom_powerline.normal.c.fg = '#ffffff'

  custom_powerline.insert.a.bg = '#25be6a'
  custom_powerline.insert.a.fg = '#000000'
  custom_powerline.insert.b.bg = '#0c3e22'
  custom_powerline.insert.b.fg = '#2ce47f'
  custom_powerline.insert.c.bg = '#0b2013'
  custom_powerline.insert.c.fg = '#2ce47f'

  custom_powerline.visual.a.bg = '#e23434'
  custom_powerline.visual.a.fg = '#000000'

  custom_powerline.replace.a.bg = '#e2df34'
  custom_powerline.replace.a.fg = '#000000'

  custom_powerline.inactive.a.bg = '#666666'
  custom_powerline.inactive.a.fg = '#000000'
  custom_powerline.inactive.b.bg = '#444444'
  custom_powerline.inactive.b.fg = '#ffffff'
  custom_powerline.inactive.c.bg = '#1c1c1c'
  custom_powerline.inactive.c.fg = '#444444'

  lualine.setup {
    options = {
      icons_enabled = true,
      theme = custom_powerline,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { mode },
      lualine_b = { branch },
      lualine_c = {
        {"diagnostics", sources = {"nvim_lsp"}},
        function()
          return "%="
        end,
        "filename"
      },
      --lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_x = { diff, spaces, "encoding"},
      lualine_y = { filetype },
      lualine_z = { location },
      --lualine_z = { progress },
      },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {"diagnostics", sources = {"nvim_lsp"}},
        function()
          return "%="
        end,
        "filename"
      },
      --lualine_c = { filename },
      lualine_x = { "location" },
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
      width = 30,
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

-- VonHeikemen/lsp-zero.nvim {{{2
-- Collection of functions to setup LSP with minimal effort
local lsp_zero_loaded, lsp_zero = pcall(require, 'lsp-zero')
if lsp_zero_loaded then
  lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
  end)
end

-- hrsh7th/nvim-cmp {{2
-- completion engine plugin for neovim written in Lua
local cmp_loaded, cmp = pcall(require, 'cmp')
if cmp_loaded then

  vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
      local opts = {buffer = event.buf}

      -- these will be buffer-local keybindings
      -- because they only work if you have an active language server

      --vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
      --vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
      --vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
      --vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
      --vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
      --vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
      --vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
      --vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
      --vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
      --vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end
  })

  local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
  local lspconfig  = require('lspconfig') 
  local mason = require('mason')
  local mason_lspconfig = require('mason-lspconfig')

  local default_setup = function(server)
    lspconfig[server].setup({
      capabilities = lsp_capabilities,
    })
  end

-- williamboman/mason.nvim {{{2
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.
--local mason_loaded, mason = pcall(require, 'mason')
--if mason_loaded then
  mason.setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })
--end

-- williamboman/mason-lspconfig.nvim {{{2
-- mason-lspconfig bridges mason.nvim with the lspconfig plugin
--local mason_lspconfig_loaded, mason_lspconfig = pcall(require, 'mason-lspconfig')
--if mason_lspconfig_loaded then
  mason_lspconfig.setup({
    ensure_installed = {},
    handlers = {
      default_setup,
      lua_ls  = function()
        lspconfig.lua_ls.setup {
          capabilities = lsp_capabilities,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT'
              },
              diagnostics = {
                globals = { "vim"}
              },
              workspace = {
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
            },
          },
        }
      end
    },
  })

  cmp.setup({
      sources = {
        {name = 'nvim_lsp'},
      },
      mapping = cmp.mapping.preset.insert({
        -- Enter key confirms completion item
        ['<CR>'] = cmp.mapping.confirm({select = false}),
        -- Ctrl + space triggers completion menu
        ['<C-Space>'] = cmp.mapping.complete(),
      }),
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
      end,
    },
  })

end

-- neovim/nvim-lspconfig {{{2
--local lspconfig_loaded, lspconfig = pcall(require, 'lspconfig')
--if lspconfig_loaded then
--  local lspconfig  = require('lspconfig') 
--  lspconfig.lua_ls.setup {
--    capabilities = lsp_capabilities,
--    settings = {
--      Lua = {
--        runtime = {
--          version = 'LuaJIT'
--        }
--        diagnostics = {
--          globals = { "vim"}
--        }
--        workspace = {
--          library = {
--            vim.env.VIMRUNTIME,
--          }
--        }
--      }
--    }
--  }
--end




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
      warn("Invalid password, sudo aborted")
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
  vim.api.nvim_exec(string.format("write! %s", tmpfile), true)
  if sudo_exec(cmd) then
    print(string.format('\r\n"%s" written', filepath))
    vim.cmd("e!")
  end
  vim.fn.delete(tmpfile)
end

-- key mapping {{{1

local map = vim.keymap.set

-- convenience mappings {{{2

-- <ctrl-s> to Save
map({ 'n', 'v', 'i'}, '<C-S>', '<C-c>:update<cr>', { silent = true })

-- open Nvim Tree
map("n", "<C-n>", ":NvimTreeToggle<CR>")

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
--map('t', '<M-r>', [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })



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

map("n", "<Tab>", ":bnext<CR>",       {})
map("n", "<S-Tab>", ":bprevious<CR>", {})

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

-- split resize
map("n", "<A-k>", ":resize -2<CR>", {silent = true})
map("n", "<A-j>", ":resize +2<CR>", {silent = true})
map("n", "<A-h>", ":vertical resize -2<CR>")
map("n", "<A-l>", ":vertical resize +2<CR>")

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

-- plugin mappings {{{3

if possession_loaded then
  map("n", "<leader>ss", function() possession.list() end)
  map("n", "<leader>sn", function() possession.new() end)
  map("n", "<leader>su", function() possession.update() end)
  map("n", "<leader>sd", function() possession.delete() end)
end

if neoscroll_loaded then
  local keymap = {
    ["J"] = function() neoscroll.ctrl_u({ duration = 250 }) end;
    ["K"] = function() neoscroll.ctrl_d({ duration = 250 }) end;
    ["gj"] = function() neoscroll.ctrl_b({ duration = 450 }) end;
    ["gk"] = function() neoscroll.ctrl_f({ duration = 450 }) end;
    --["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor=false; duration = 100 }) end;
    --["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor=false; duration = 100 }) end;
    --["zt"]    = function() neoscroll.zt({ half_win_duration = 250 }) end;
    --["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end;
    --["zb"]    = function() neoscroll.zb({ half_win_duration = 250 }) end;
  }
  local modes = { 'n', 'v', 'x' }
  for key, func in pairs(keymap) do
    vim.keymap.set(modes, key, func)
  end
end


--  map("n", "<leader>ss", function() require("nvim-possession").list() end)
--  map("n", "<leader>sn", function() possession.new() end)
--  map("n", "<leader>su", function() possession.update() end)
--  map("n", "<leader>sd", function() possession.delete() end)
--end

-- <leader>v|<leader>s act as <cmd-v>|<cmd-s>
-- <leader>p|P paste from yank register (0)
-- <leader>y|Y yank into clipboard/OSCyank
map({'n', 'v'}, '<leader>v', '"+p',   {})
map({'n', 'v'}, '<leader>V', '"+P',   {})
--map({'n', 'v'}, '<leader>s', '"*p',   {})
--map({'n', 'v'}, '<leader>S', '"*P',   {})
map({'n', 'v'}, '<leader>p', '"0p',   {})
map({'n', 'v'}, '<leader>P', '"0P',   {})
map({'n', 'v'}, '<leader>y', '<cmd>OSCYankReg 0<CR>', {})
-- map({'n', 'v'}, '<leader>y', '<cmd>let @+=@0<CR>', {})

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


