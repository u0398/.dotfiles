
local opt  = vim.opt -- global
local g  = vim.g     -- global for let options
local wo = vim.wo    -- window local
local bo = vim.bo    -- buffer local
local fn = vim.fn    -- access vim functions
local cmd = vim.cmd  -- vim commands
local map = require('core.utils').map -- import map helper

-- https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md#patches
--if vim.fn.has('patch-8.1.1366') then
--    vim.opt.modelines=5
--    vim.opt.modelineexpr = false
--    vim.opt.modeline = true
--else
--    vim.opt.modeline = false
--end

-- IMPROVE NEOVIM STARTUP
-- https://github.com/editorconfig/editorconfig-vim/issues/50
vim.g.loaded_python_provier = 0
vim.g.loaded_python3_provider = 0
vim.g.python_host_skip_check = 1
vim.g.python_host_prog='/bin/python2'
vim.g.python3_host_skip_check = 1
vim.g.python3_host_prog='/bin/python3'
vim.opt.pyxversion=3

-- if vim.fn.executable("editorconfig") then
--  vim.g.EditorConfig_exec_path = '/bin/editorconfig'
-- end
--vim.g.EditorConfig_core_mode = 'external_command'

-- https://vi.stackexchange.com/a/5318/7339
vim.g.matchparen_timeout = 20
vim.g.matchparen_insert_timeout = 20

-- disable builtins plugins
local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "matchit",
    "netrw",
    "netrwFileHandlers",
    "loaded_remote_plugins",
    "loaded_tutor_mode_plugin",
    "netrwPlugin",
    "netrwSettings",
    "rrhelper",
    "spellfile_plugin",
    "tar",
    "tarPlugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "matchparen", -- matchparen.nvim disables the default
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

g.mapleader = ","

--vim.cmd("hi normal guibg=NONE ctermbg=NONE")
-- https://www.codesd.com/item/how-do-i-open-the-quickfix-window-instead-of-displaying-grep-results.html
-- vim.cmd([[command! -bar -nargs=1 Grep silent grep <q-args> | redraw! | cw]])
--vim.cmd([[cnoreab cls Cls]])
--vim.cmd([[command! Cls lua require("core.utils").preserve('%s/\\s\\+$//ge')]])
--vim.cmd([[command! Reindent lua require('core.utils').preserve("sil keepj normal! gg=G")]])
--vim.cmd([[command! BufOnly lua require('core.utils').preserve("silent! %bd|e#|bd#")]])
--vim.cmd([[cnoreab Bo BufOnly]])
--vim.cmd([[cnoreab W w]])
--vim.cmd([[cnoreab W! w!]])
--vim.cmd([[command! CloneBuffer new | 0put =getbufline('#',1,'$')]])
--vim.cmd([[command! Mappings drop ~/.config/nvim/lua/user/mappings.lua]])
--vim.cmd([[command! Scratch new | setlocal bt=nofile bh=wipe nobl noswapfile nu]])
--vim.cmd([[syntax sync minlines=64]]) --  faster syntax hl

-- save as root, in my case I use the command 'doas'
vim.cmd([[cmap w!! w !doas tee % >/dev/null]])
vim.cmd([[command! SaveAsRoot w !doas tee %]])

-- vim.cmd([[hi ActiveWindow ctermbg=16 | hi InactiveWindow ctermbg=233]])
-- vim.cmd([[set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow]])

vim.cmd('command! ReloadConfig lua require("utils").ReloadConfig()')

-- inserts filename and Last Change: date
--vim.cmd([[inoreab lc -- File: <c-r>=expand("%:p")<cr><cr>-- Last Change: <c-r>=strftime("%b %d %Y - %H:%M")<cr><cr>]])

--vim.cmd([[inoreab Fname <c-r>=expand("%:p")<cr>]])
--vim.cmd([[inoreab Iname <c-r>=expand("%:p")<cr>]])
--vim.cmd([[inoreab fname <c-r>=expand("%:t")<cr>]])
--vim.cmd([[inoreab iname <c-r>=expand("%:t")<cr>]])

--vim.cmd([[inoreabbrev idate <C-R>=strftime("%b %d %Y %H:%M")<CR>]])
--vim.cmd([[cnoreab cls Cls]])

--vim.cmd([[highlight RedundantSpaces ctermbg=red guibg=red ]])
--vim.cmd([[match RedundantSpaces /\s\+$/]])

vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
      vim.cmd "quit"
    end
  end
})

local options = {
--    ssop = vim.opt.ssop - { "blank", "help", "buffers" } + { "terminal" },
    modelines = 5,
    modelineexpr = false,
    modeline = true,
    emoji = false, -- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
    undofile = true,
    shada = "!,'30,<30,s30,h,:30,%0,/30",
    whichwrap = opt.whichwrap:append "<>[]hl",
    iskeyword = opt.iskeyword:append "-",
    listchars = { eol = "↲", tab = "▶ ", trail = "•", precedes = "«", extends = "»", nbsp = "␣", space = "." },
    completeopt = "menu,menuone,noselect",
    encoding = "utf-8",    -- str:  String encoding to use
    fileencoding = "utf8", -- str:  File encoding to use
    syntax = "ON",        -- str:  Allow syntax highlighting
    foldenable = false,
    foldopen = vim.opt.foldopen + "jump", -- when jumping to the line auto-open the folder
    foldmethod = "indent",
    path = vim.opt.path + "~/.config/nvim/lua/user",
    path = vim.opt.path + "**",
    wildignore = { ".git", ".hg", ".svn", "*.pyc", "*.o", "*.out", "*.jpg", "*.jpeg", "*.png", "*.gif", "*.zip" },
    wildignore = vim.opt.wildignore + { "**/node_modules/**", "**/bower_modules/**", "__pycache__", "*~", "*.DS_Store" },
    wildignore = vim.opt.wildignore + { "**/undo/**", "*[Cc]ache/" },
    wildignorecase = true,
    infercase = true,
    lazyredraw = true,
    showmatch = true,
    switchbuf = useopen,
    matchtime = 2,
    synmaxcol = 128, -- avoid slow rendering for long lines
    shell = "/bin/zsh",
    pumheight = 10,
    pumblend = 15,
    wildmode = "longest:full,full",
    timeoutlen = 500,
    ttimeoutlen = 30, -- https://vi.stackexchange.com/a/4471/7339
    hlsearch = true, -- Highlight found searches
    ignorecase = true, -- Ignore case
    inccommand = "nosplit", -- Get a preview of replacements
    incsearch = true, -- Shows the match while typing
    joinspaces = false, -- No double spaces with join
    linebreak = true, -- Stop words being broken on wrap
    list = false, -- Show some invisible characters
    relativenumber = true,
    scrolloff = 2, -- Lines of context
    shiftround = true, -- Round indent
    shiftwidth = 2, -- Size of an indent
    expandtab = true,
    showmode = true, -- Display mode
    sidescrolloff = 8, -- Columns of context
    signcolumn = "yes:1", -- always show signcolumns
    smartcase = true, -- Do not ignore case with capitals
    smartindent = true, -- Insert indents automatically
    spelllang = { "en_us" },
    splitbelow = true, -- Put new windows below current
    splitright = true, -- Put new windows right of current
    tabstop = 2, -- Number of spaces tabs count for
    termguicolors = true, -- You will have bad experience for diagnostic messages when it's default 4000.
    wrap = true,
    mouse = "iv",
    undodir = "/tmp",
    undofile = true,
    fillchars = { eob = "~" },
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

if vim.fn.executable("rg") then
    -- if ripgrep installed, use that as a grepper
    vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
    vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end
--lua require("notify")("install ripgrep!")

--if vim.fn.executable("prettier") then
--    opt.formatprg = "prettier --stdin-filepath=%"
--end
--lua require("notify")("Install prettier formater!")

opt.formatoptions = "l"
opt.formatoptions = opt.formatoptions
    - "a" -- Auto formatting is BAD.
    - "t" -- Don't auto format my code. I got linters for that.
    + "c" -- In general, I like it when comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2" -- I'm not in gradeschool anymore

--opt.guicursor = {
--    "n-v-c-sm:block",
--    "i-ci-ve:ver25",
--    "r-cr:hor20",
--    "o:hor50",
--    "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
--    "sm:block-blinkwait175-blinkoff150-blinkon175",
--}

-- window-local options
window_options = {
  numberwidth = 3,
  number = true,
  relativenumber = false,
  linebreak = true,
  cursorline = false,
  foldenable = false,
}

for k, v in pairs(window_options) do
  vim.wo[k] = v
end

-- buffer-local options
buffer_options = {
  expandtab = true,
  softtabstop = 2,
  tabstop = 2,
  shiftwidth = 2,
  smartindent = true,
  suffixesadd = '.lua'
}

for k, v in pairs(buffer_options) do
  vim.bo[k] = v
end

vim.g.nojoinspaces = true
