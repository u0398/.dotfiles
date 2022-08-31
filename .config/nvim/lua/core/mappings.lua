-- https://oroques.dev/notes/neovim-init/
-- https://blog.devgenius.io/create-custom-keymaps-in-neovim-with-lua-d1167de0f2c2
local map = require('core.utils').map

--- Map leader to comma
vim.g.mapleader = ","

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize with arrows
map("n", "<A-k>", ":resize -2<CR>", {silent = true})
map("n", "<A-j>", ":resize +2<CR>", {silent = true})
map("n", "<A-h>", ":vertical resize -2<CR>")
map("n", "<A-l>", ":vertical resize +2<CR>")

-- 
map('n', '<capslock>', 'ns')


-- Move text up and down
--map("n", "<A-j>", "<Esc>:m .+1<CR>==gi")
--map("n", "<A-k>", "<Esc>:m .-2<CR>==gi")
-- Move text up and down
--map("v", "<A-j>", ":m .+1<CR>==")
--map("v", "<A-k>", ":m .-2<CR>==")
-- keymap("v", "p", '"_dP')

-- Visual --
-- Stay in indent mode
--map("v", "<", "<gv")
--map("v", ">", ">gv")

-- Visual Block --
-- Move text up and down
--map("x", "J", ":move '>+1<CR>gv-gv")
--map("x", "K", ":move '<-2<CR>gv-gv")
--map("x", "<A-j>", ":move '>+1<CR>gv-gv")
--map("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

---- line text-objects (inner and whole line text-objects)
---- I am trying now to create some "inner next object", "around last object" and
---- these mappings conflict with the mappings bellow, so, I am disabling those for a while
--map("x", "al", ":<C-u>norm! 0v$<cr>")
--map("x", "il", ":<C-u>norm! _vg_<cr>")
--map("o", "al", ":norm! val<cr>")
--map("o", "il", ":norm! vil<cr>")

-- other interesting text objects
-- reference: https://www.reddit.com/r/vim/comments/adsqnx/comment/edjw792
-- TODO: detect if we are over the first char and jump to the right
--local chars = { "_", "-", ".", ":", ",", ";", "<bar>", "/", "<bslash>", "*", "+", "%", "#", "`" }
--for k, v in ipairs(chars) do
--    map("x", "i" .. v, ":<C-u>norm! T" .. v .. "vt" .. v .. "<CR>")
--    map("x", "a" .. v, ":<C-u>norm! F" .. v .. "vf" .. v .. "<CR>")
--    map("o", "a" .. v, ":normal! va" .. v .. "<CR>")
--    map("o", "i" .. v, ":normal! vi" .. v .. "<CR>")
--end

-- charactere under the cursor
--local char = vim.fn.strcharpart(vim.fn.strpart(vim.fn.getline("."), vim.fn.col(".") - 1), 0, 1)
--print(char)

-- for k, v in ipairs(chars) do
--     map("o", "an" .. v, ":norm! f" .. v .. "vf" .. v .. "<CR>")
--     map("o", "in" .. v, ":norm! f" .. v .. "lvt" .. v .. "<CR>")
--     map("o", "al" .. v, ":norm! F" .. v .. "vF" .. v .. "<CR>")
--     map("o", "il" .. v, ":norm! F" .. v .. "hvT" .. v .. "<CR>")
--     map("x", "an" .. v, ":<c-u>norm! f" .. v .. "vf" .. v .. "<CR>")
--     map("x", "in" .. v, ":<c-u>norm! f" .. v .. "lvt" .. v .. "<CR>")
--     map("x", "al" .. v, ":<c-u>norm! F" .. v .. "vF" .. v .. "<CR>")
--     map("x", "il" .. v, ":<c-u>norm! F" .. v .. "hvT" .. v .. "<CR>")
-- end

--map("v", "<Leader>y", '"+y')

-- glow (markdow preview)
--map('n', '<C-M-g', '<cmd>Glow<CR>')

-- terminal mappings
-- Notice: There are other mappings in the which-key file settings!
--         but they will only work after some delay
--         you can also call "vertical and float" terminals
map("n", "<leader>t", "<cmd>new term://zsh<cr>")

-- copy to the primary selection on mouse release
--map("v", "<LeftRelease>", '"*y')

-- jump to the last changed spot
--map("n", "gl", "`.")

-- Nvim Tree
-- map("n", "<leader>e", ":PackerLoad nvim-tree.lua | NvimTreeToggle<CR>", { silent = true })
--map("n", "<leader>e", ":PackerLoad nvim-tree.lua<cr>:NvimTreeToggle<CR>", { silent = true })
--map("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
--map("n", "<F11>", ":PackerLoad nvim-tree.lua<cr>:NvimTreeFindFile<CR>", { silent = true })

-- two commands at once to load plugin and then use it!
-- map("n", "<F4>", ":PackerLoad undotree<cr>:UndotreeToggle<cr>", { silent = true })

--map("n", "<F4>", ":set invpaste paste?<cr>")
--map("i", "<F4>", "<c-o>:set invpaste paste?<cr>")

-- Update Plugins
map("n", "<Leader>u", ":PackerSync<CR>")

-- Open nvimrc file
--map("n", "<Leader>v", "<cmd>drop $MYVIMRC<CR>")
--map("n", "<Leader>z", "<cmd>drop ~/.zshrc<CR>")

-- Source nvimrc file
--map("n", "<Leader>sv", ":luafile %<CR>")

-- Quick new file
-- map("n", "<Leader>n", "<cmd>enew<CR>")

-- nvim file
--map('n', '<Leader>n', "<cmd>lua require('core.files').nvim_files()<CR>")

-- Make visual yanks place the cursor back where started
-- map("v", "y", "ygv<Esc>")
-- https://ddrscott.github.io/blog/2016/yank-without-jank/
--vim.cmd([[vnoremap <expr>y "my\"" . v:register . "y`y"]])

-- Easier file save
--map("n", "<Delete>", "<cmd>:update!<CR>")
--map("n", "<F9>", "<cmd>update<cr>")
--map("i", "<F9>", "<c-o>:update<cr>")

-- Cheatsheet plugin (show your mappings)
--map("n", "<F12>", "<cmd>Cheatsheet<cr>")

-- discard buffer
-- fixing a temporary issue: https://github.com/dstein64/nvim-scrollview/issues/10
-- famiu/bufdelete.nvim
--map("n", "<leader>x", ":wsh | up | sil! bdelete<cr>", { silent = true })
--map("n", "<leader>w", ":bwipeout!<cr>", { silent = true })

-- select last paste in visual mode
--map("n", "<leader>p", "'`[' . strpart(getregtype(), 0, 1) . '`]'", { expr = true })

-- It adds motions like 25j and 30k to the jump list, so you can cycle
-- through them with control-o and control-i.
-- source: https://www.vi-improved.org/vim-tips/
--map("n", "j", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj']], { expr = true })
--map("n", "k", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk']], { expr = true })

-- type c* (perform your substitution Esc) then "n" and "."
--map("n", "<leader><leader>", ":b#<cr>")
--map("n", "c*", "*<c-o>cgn")
--map("n", "c#", "#<c-o>cgn")
-- map("n", "<leader>g", "*<c-o>cgn")

-- avoid clipboard hacking security issue
-- http://thejh.net/misc/website-terminal-copy-paste
-- inoremap <C-R>+ <C-r><C-o>+
--map("i", "<C-r>+", "<C-r><C-o>+")
--map("i", "<S-Insert>", "<C-r><C-o>+")

-- two clicks in a word makes a count
--map("n", "<2-LeftMouse>", [[:lua require('core.utils').CountWordFunction()<cr>]], { silent = true })
--map("n", "<RightMouse>", "<cmd>match none<cr>")

-- show current buffer
-- map("n", "<C-m-t>", [[:lua require('notify')(vim.fn.expand('%:p'))<cr>:lua require('core.utils').flash_cursorline()<cr>]])

-- deletes the rest of the line in command mode
--map("c", "<c-k>", [[<c-\>egetcmdline()[:getcmdpos()-2]<CR>]])

-- <Tab> to navigate the completion menu
--map("i", "<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true })
--map("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', { expr = true })

-- More molecular undo of text
-- map("i", ",", ",<c-g>u")
--map("i", ".", ".<c-g>u")
--map("i", "!", "!<c-g>u")
--map("i", "?", "?<c-g>u")
--map("i", ";", ";<c-g>u")
--map("i", ":", ":<c-g>u")
--map("i", "]", "]<c-g>u")
--map("i", "}", "}<c-g>u")

-- map("n", "<F3>", '<cmd>lua require("harpoon.mark").add_file(vim.fn.expand("%:p"))<cr>')
-- map("n", "<S-F3>", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>')

-- https://stackoverflow.com/a/37897322
-- https://neovim.discourse.group/t/how-to-append-mappings-in-lua/2118
-- use maparg
-- https://vi.stackexchange.com/a/36950/7339
-- nnoremap n nzz:call FlashCursorLine()<CR>Nn
--map('n', 'n', 'nzz:lua require("core.utils").flash_cursorline()<CR>Nn')
--map('n', 'N', 'Nzz:lua require("core.utils").flash_cursorline()<CR>nN')
--map('n', '*', '*:lua require("core.utils").flash_cursorline()<CR><CR>')
--map('n', '#', '#:lua require("core.utils").flash_cursorline()<CR><CR>')

--map("n", "J", "mzJ`z")
--map("n", "<C-o>", '<C-o>zv:lua require("core.utils").flash_cursorline()<CR>')
--map("n", "<C-i>", '<C-i>zv:lua require("core.utils").flash_cursorline()<CR>')
-- map("n", "<c-o>", '<c-o>zv:Beacon<cr>', { silent = true })
-- map("n", "<c-i>", '<c-i>zv:Beacon<cr>', { silent = true })

-- -- TODO: include neoscroll command
-- map("n", "<c-d>", ':lua require("neoscroll").scroll(vim.wo.scroll, true, 300)<CR><BAR>lua require("core.utils").flash_cursorline()<cr>', { silent = true })
-- map("n", "<c-u>", ':lua require("neoscroll").scroll(-10, true, 300)<CR><BAR>lua require("core.utils").flash_cursorline()<cr>', { silent = true })

-- better gx mapping
-- https://sbulav.github.io/vim/neovim-opening-urls/
--map("", "gx", '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>', {})

-- quickfix mappings
--map('n', '[q', ':cprevious<CR>')
--map('n', ']q', ':cnext<CR>')
--map('n', ']Q', ':clast<CR>')
--map('n', '[Q', ':cfirst<CR>')

-- Reselect visual when indenting
--map("x", ">", ">gv")
--map("x", "<", "<gv")

-- Selecting your pasted text
-- map gp `[v`]
-- https://www.reddit.com/r/vim/comments/4aab93 ]]
-- map("n", "gV", "`[V`]")
--map("n", "gV", [['`[' . strpart(getregtype(), 0, 1) . '`]']], { expr = true })

-- -- if there is a fold under cursor open it by pressing <CR> otherwise do
-- -- what <CR> does
-- map('n', '<CR>', [[@=(foldlevel('.')?'za':"\<Space>")<CR>]], map_opts)

--map( "n", "<C-l>", [[ (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n" <BAR> redraw<CR>]], { silent = true, expr = true })

-- Make Y yank to end of the line
--map("n", "Y", "yg_")

-- shortcuts to jump in the command line
map("c", "<C-s>", "<home>")
map("c", "<C-e>", "<end>")

--map("i", "<s-cr>", "<c-o>o")
--map("i", "<c-cr>", "<c-o>O")

--nnoremap <expr> oo 'm`' . v:count1 . 'o<Esc>``'
--nnoremap <expr> OO 'm`' . v:count1 . 'O<Esc>``'

--map("n", "ç", ":")
--map("n", "<space>", "/")

-- Better window movement
-- map("n", "<C-h>", "<C-w>h", { silent = true })
-- map("n", "<C-j>", "<C-w>j", { silent = true })
-- map("n", "<C-k>", "<C-w>k", { silent = true })
-- map("n", "<C-l>", "<C-w>l", { silent = true })

-- Line bubbling
-- Move selected line / block of text in visual mode
--map("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
--map("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

-- Make the dot command work as expected in visual mode (via
-- https://www.reddit.com/r/vim/comments/3y2mgt/
--map("v", ".", ":norm .<cr>")

-- close buffer without loosing the opened window
map("n", "<C-c>", ":new|bd #<CR>", { silent = true })

-- close buffer
map("n", "<C-x>", ":BufferClose<CR>", { silent = true })

--map('n', '<leader>d', '<cmd>lua require("core.utils").squeeze_blank_lines()<cr>')

--map("n", "<space>fb", "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>", { noremap = true })

-- telescope mappings

map('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>]])
map('n', '<leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]])
map('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<cr>]])
map('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]])
map('n', '<leader>ft', [[<cmd>lua require('telescope.builtin').treesitter()<cr>]])

-- map("n", "<leader>o", ':lua require("telescope.builtin").oldfiles()<cr>') -- already mapped on which-key
--map("n", "<C-M-o>", ':lua require("core.files").search_oldfiles()<CR>') -- already mapped on which-key
-- cd ~/.dotfiles/wiki | Telescope find_files
--map("n", "<c-p>", [[<cmd>lua require("telescope.builtin").find_files{cwd = "~/.dotfiles"}<cr>]], { silent = true })
--map("n", "<c-p>", [[<cmd>lua require('core.files').search_dotfiles()<cr>]], { silent = true })
--map("n", "<F8>", [[<cmd>lua require("telescope.builtin").find_files{cwd = "~/.config"}<cr>]], { silent = true })
--map("n", "<F8>", [[<cmd>lua require("core.files").xdg_config()<cr>]], { silent = true })
-- map('n', '<F8>', [[<cmd>lua require("telescope.builtin").find_files{cwd = "~/.config/nvim"}<cr>]], {silent = true})
-- map("n", "<leader>f", [[<cmd>lua require('telescope.builtin').find_files()<cr>]], { silent = true })
-- map("n", "<leader>b", [[<cmd>lua require('telescope.builtin').buffers()<cr>]], { silent = true })
--map('n', '<leader>b', [[<Cmd>lua require('core.files').buffers()<CR>]])
-- map(
--     "n",
--     "<leader>b",
--     [[<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>")]]
-- )
--map("n", "<leader>l", [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]], { silent = true })
-- map('n', '<leader>t', [[<cmd>lua require('telescope.builtin').tags()<cr>]], {  silent = true})
--map("n", "<leader>?", [[<cmd>lua require('telescope.builtin').oldfiles()<cr>]], { silent = true })
--map("n", "<leader>sd", [[<cmd>lua require('telescope.builtin').grep_string()<cr>]], { silent = true })
--map(
--    "n",
--    "<leader>sp",
--    [[<cmd>lua require('telescope.builtin').live_grep{cwd = "~/.dotfiles/wiki"}<cr>]],
--    { silent = true }
--)
-- map('n', '<leader>o', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<cr>]], {  silent = true})
--map("n", "<leader>gc", [[<cmd>lua require('telescope.builtin').git_commits()<cr>]], { silent = true })
--map("n", "<leader>gb", [[<cmd>lua require('telescope.builtin').git_branches()<cr>]], { silent = true })
--map("n", "<leader>gs", [[<cmd>lua require('telescope.builtin').git_status()<cr>]], { silent = true })
--map("n", "<leader>gp", [[<cmd>lua require('telescope.builtin').git_bcommits()<cr>]], { silent = true })
-- end of telescope mappings

-- gitsigns mappings:
--map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
--map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

-- reload snippets.lua
--map('n', '<leader><leader>s', '<cmd>source ~/.config/nvim/after/plugin/snippets.lua<cr>')

-- avoid entering Ex mode by accident
--map('n', 'Q', '<Nop>')

-- restore the last session
--map("n", "<F5>", [[<cmd>lua require("persisted").load({ last = true })<cr>]])
--map("n", "<leader>qx", [[<cmd>lua require("persisted").stop()<cr>]])

-- nmap <F5> :windo set scrollbind!<cr>
-- map('n', '<F5>', ':windo set scrollbind!<CR>')

-- stop Persisted => session won't be saved on exit

-- Easy add date/time
-- map("n", "<Leader>t", "\"=strftime('%c')<CR>Pa", { silent = true })

-- Telescope
--map("n", "<Leader>1", ":Telescope sessions [save_current=true]<CR>")
-- map("n", "<leader>p", '<cmd>lua require("telescope.builtin").find_files()<cr>')
--map("n", "<leader>p", "<cmd>lua require'telescope.builtin'.find_files({find_command={'fd','--no-ignore-vcs'}})")
--map("n", "<leader>r", '<cmd>lua require("telescope.builtin").registers()<cr>')
--map("n", "<leader>g", '<cmd>lua require("telescope.builtin").live_grep()<cr>')
-- map("n", "<leader>b", '<cmd>lua require("telescope.builtin").buffers()<cr>')
--map("n", "<leader>j", '<cmd>lua require("telescope.builtin").help_tags()<cr>')
--map("n", "<leader>h", '<cmd>lua require("telescope.builtin").git_bcommits()<cr>')
-- map("n", "<leader>f", '<cmd>lua require("telescope").extensions.file_browser.file_browser()<CR>')
--map("n", "<leader>s", '<cmd>lua require("telescope.builtin").spell_suggest()<cr>')
--map("n", "<leader>i", '<cmd>lua require("telescope.builtin").git_status()<cr>')
--map("n", "<leader>ca", '<cmd>lua require("telescope.builtin").lsp_code_actions()<cr>')
--map("n", "<leader>cs", '<cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>')
--map("n", "<leader>cd", '<cmd>lua require("telescope.builtin").lsp_document_diagnostics()<cr>')
--map("n", "<leader>cr", '<cmd>lua require("telescope.builtin").lsp_references()<cr>')

--map("i", "<F2>", '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
--map("n", "<leader>cn", '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
--map("v", "<leader>cn", '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })

-- change colors
-- map("n", "<F6>", [[<cmd>lua require("core.utils").toggle_colors()<cr>]])
--map("n", "<F6>", ":lua require('core.colors').choose_colors()<CR>" )
--map('n', '<C-Right>', ':lua require("core.utils").toggle_colors()<CR><Bar>colo<CR>')

-- map("n", "<F2>", [[<cmd>lua require("core.utils").toggle_transparency()<cr>]])

-- toggle list
-- set list! | :echo (&list == 1 ? "list enabled" : "list disabled")
--map("n", "<c-m-l>", ":set list!<CR>:echo (&list == 1 ? 'list enabled' : 'list disabled')<CR>")
--map("i", "<c-m-l>", "<C-o>:set list!<CR><C-o>:echo (&list == 1 ? 'list enabled' : 'list disabled')<CR>")

--map("n", "<F7>", "[[:let &background = ( &background == 'dark'? 'light' : 'dark' )<CR>]]", { silent = true })

--map("n", "<leader>ci", "<cmd> lua vim.diagnostic.open_float()<cr>")

-- Easier split mappings
map("n", "<A-Down>", "<C-W><C-J>", { silent = true })
map("n", "<A-Up>", "<C-W><C-K>", { silent = true })
map("n", "<A-Right>", "<C-W><C-L>", { silent = true })
map("n", "<A-Left>", "<C-W><C-H>", { silent = true })
--map("n", "<A-j>", "<C-W><C-J>", { silent = true })
--map("n", "<A-k>", "<C-W><C-K>", { silent = true })
--map("n", "<A-l>", "<C-W><C-L>", { silent = true })
--map("n", "<A-h>", "<C-W><C-H>", { silent = true })
map("n", "<A-[>;", "<C-W>-", { silent = true })
map("n", "<A-]>;", "<C-W>+", { silent = true })
--map("n", "<Leader>[", "<C-W>_", { silent = true })
--map("n", "<Leader>[", "<C-W>_", { silent = true })
--map("n", "<Leader>]", "<C-W>|", { silent = true })
--map("n", "<Leader>=", "<C-W>=", { silent = true })

--map('n', '<leader>a', ':Alpha<CR>')

-- -- Hop
-- map("n", "h", "<cmd>lua require'hop'.hint_words()<cr>")
-- map("n", "l", "<cmd>lua require'hop'.hint_lines()<cr>")
-- map("v", "h", "<cmd>lua require'hop'.hint_words()<cr>")
-- map("v", "l", "<cmd>lua require'hop'.hint_lines()<cr>")

-- Symbols outline
-- map("n", "<leader>o", ":SymbolsOutline<cr>")

-- barbar mappings

-- -- -- Move to previous/next
--map("n", "<A-,>", ":BufferPrevious<CR>")
--map("n", "<A-.>", ":BufferNext<CR>")

-- Tab to switch buffers in Normal mode
--map("n", "<Tab>", ":bnext<CR>")
--map("n", "<S-Tab>", ":bprevious<CR>")
-- -- Navigate buffers
map("n", "<Tab>", ":bnext<CR>", { silent = true})
map("n", "<S-Tab>", ":bprevious<CR>", { silent = true})
-- useful for presntations
--map('n', '<Right>', ':bnext<CR> :redraw<CR>', { silent = true})
--map('n', '<Left>', ':bnext<CR> :redraw<CR>', { silent = true})

-- alternate file mapping (add silent true)
--map('n', '<bs>',
--	[[:<c-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<cr>]],
--	{ silent = true, noremap = true } )

-- -- Move to previous/next (tabline)
map("n", "<A-.>", ":BufferNext<CR>")
map("n", "<A-,>", ":BufferPrevious<CR>")

-- -- Re-order to previous/next
map("n", "<A-<>", ":BufferMovePrevious<CR>")
map("n", "<A->>", ":BufferMoveNext<CR>")

-- Goto buffer in position...
map("n", "<A-1>", ":BufferGoto 1<CR>")
map("n", "<A-2>", ":BufferGoto 2<CR>")
map("n", "<A-3>", ":BufferGoto 3<CR>")
map("n", "<A-4>", ":BufferGoto 4<CR>")
map("n", "<A-5>", ":BufferGoto 5<CR>")
map("n", "<A-6>", ":BufferGoto 6<CR>")
map("n", "<A-7>", ":BufferGoto 7<CR>")
map("n", "<A-8>", ":BufferGoto 8<CR>")
map("n", "<A-9>", ":BufferLast<CR>")
-- Pin/unpin buffer
--map("n", "<A-p>", ":BufferPin<CR>")
-- Close buffer
map("n", "<A-c>", ":BufferPin<CR>")

map("n", "<C-n>", ":NvimTreeToggle<CR>")
-- Wipeout buffer
-- :BufferWipeout<CR>
-- Close commands
-- :BufferCloseAllButCurrent<CR>
-- :BufferCloseAllButPinned<CR>
-- :BufferCloseBuffersLeft<CR>
-- :BufferCloseBuffersRight<CR>

-- Magic buffer-picking mode
--map("n", "<C-s>", ":BufferPick<CR>")

-- Sort automatically by...
--map("n", "<Space>bb", ":BufferOrderByBufferNumber<CR>")
--map("n", "<Space>bd", ":BufferOrderByDirectory<CR>")
--map("n", "<Space>bl", ":BufferOrderByLanguage<CR>")
--map("n", "<Space>bw", ":BufferOrderByWindowNumber<CR>")

-- Allow saving of files as sudo when I forgot to start vim using sudo.
-- http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
--map('c', 'w!!', [[%!sudo tee > /dev/null %]], { noremap = true, silent = true })

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
