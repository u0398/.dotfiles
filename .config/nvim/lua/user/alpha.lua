-- File: /home/sergio/.config/nvim/lua/user/alpha.lua
-- Last Change: Thu, 10 Mar 2022 17:38

local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local dashboard = require "alpha.themes.dashboard"
math.randomseed(os.time())

local function button(sc, txt, keybind, keybind_opts)
  local b = dashboard.button(sc, txt, keybind, keybind_opts)
  b.opts.hl = "Function"
  b.opts.hl_shortcut = "Type"
  return b
end

local function pick_color()
  local colors = { "String", "Identifier", "Keyword", "Number", "Constant" }
  return colors[math.random(#colors)]
end

-- local function footer()
--   local plugins = #vim.tbl_keys(packer_plugins)
--   local v = vim.version()
--   local datetime = os.date " %d-%m-%Y   %H:%M:%S"
--   return string.format(" %s   v%s.%s.%s  %s", plugins .. " plugins", v.major, v.minor, v.patch, datetime)
-- end

local function footer()
  local total_plugins = #vim.tbl_keys(packer_plugins)
  local date = os.date("%d-%m-%Y")
  local time = os.date("%H:%M:%S")
  return "[ " .. total_plugins .. " plugins]   [ " .. date .. "]   [ " .. time .. "]"
end

-- dashboard.section.header.val = {
--   [[ _______             ____   ____.__]],
--   [[ \      \   ____  ___\   \ /   /|__| _____]],
--   [[ /   |   \_/ __ \/  _ \   Y   / |  |/     \]],
--   [[/    |    \  ___(  <_> )     /  |  |  Y Y  \]],
--   [[\____|__  /\___  >____/ \___/   |__|__|_|  /]],
--   [[        \/     \/                        \/]],
-- }

dashboard.section.header.val = {
-- "",
-- "",
-- "",
"   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆",
"    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦",
"          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄",
"           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄",
"          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀",
"   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄",
"  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄",
" ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄",
" ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄",
"      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆",
"       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃",
--"",
}

dashboard.section.header.opts.hl = pick_color()

-- dashboard.section.buttons.val = {
--   button("SPC t o", "  Recently opened files"),
--   button("SPC t f", "  Find file"),
--   button("SPC t l", "  Find word"),
--   button("SPC t F", "   File browser"),
--   button("SPC t 1", "  Find repo"),
--   button("SPC s s", "  Open session"),
--   button("SPC c n", "  New file"),
--   button("SPC c c", "  Update plugins"),
--   button("q", "  Quit", "<Cmd>qa<CR>"),
-- }

dashboard.section.buttons.val = {
    -- dashboard.button("r", "  Recently opened files", "<Cmd>lua require('core.files').search_oldfiles()<CR>"),
	-- dashboard.button("s", "  Restore Session", "<cmd>lua require('persisted').load({ last = true })<cr>" ),
    dashboard.button("n", "  New file", "<Cmd>ene<CR>"),
    dashboard.button("g", "  Grep ~/.dotfiles", ":lua require('core.files').grep_dotfiles()<CR>"),
    dashboard.button("f", "  Dotfiles", ":lua require('core.files').search_dotfiles()<CR>"),
    -- dashboard.button("i", "  Config init.lua", ":e $MYVIMRC<CR>"),
    dashboard.button("u", "  Update plugins", "<Cmd>PackerSync<CR>"),
    dashboard.button("q", "  Quit", "<Cmd>qa<CR>"),
}

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = dashboard.section.header.opts.hl

dashboard.config.layout[1].val = 1

require("alpha").setup(dashboard.config)

-- hide tabline and statusline on startup screen
vim.cmd [[
augroup alpha_tabline
  au!
  au FileType alpha set showtabline=0 laststatus=0 noruler | au BufUnload <buffer> set showtabline=2 ruler laststatus=2
augroup END
]]

