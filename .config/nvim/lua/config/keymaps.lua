local utils = require'config.utils'
local map = vim.keymap.set

-- convenience mappings {{{2

-- <ctrl-s> to Save
map({ 'n', 'v', 'i'}, '<C-S>', '<C-c>:update<cr>', { silent = true })

-- open Nvim Tree
-- map("n", "<leader>ft", ":Neotree<CR>")

-- clear highlight search with <esc>
map( {'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear hlsearch' })

map( 'n',           -- Clear search, diff update and redraw
     '<esc><esc>',  -- taken from runtime/lua/_editor.lua
     '<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><cr>',
     { desc = 'Redraw / Clear hlsearch / Diff Update' } )

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]",      { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]",      { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]",      { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]",      { expr = true, desc = "Prev Search Result" })

-- shortcut to view :messages
map({'n', 'v'}, '<leader>m', '<cmd>messages<CR>',  {})
map({'n', 'v'}, '<leader>M', '<cmd>mes clear|echo "cleared :messages"<CR>', {})

-- shortcut to view fidget history
map({'n', 'v'}, '<leader>n', '<cmd>Fidget history<CR>',  {})
map({'n', 'v'}, '<leader>N', '<cmd>Fidget clear_history<CR>', {})

-- Change current working dir (:pwd) to curent file's folder
map('n', '<leader>%', function() utils.set_cwd() end, { silent = true })

-- Map <leader>o & <leader>O to newline without insert mode
map('n', '<leader>o',
    ':<C-u>call append(line("."), repeat([""], v:count1))<CR>',
    { silent = true })
map('n', '<leader>O',
    ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
    { silent = true })

-- newline with comments
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
--- w!! to save with sudo
map('c', 'w!!', function() utils.sudo_write() end, { silent = true })

-- Break undo chain on punctuation, parenthesis, quotes, and carriage return
-- so we can use 'u' to undo sections of an edit
for _, c in ipairs({',', '.', '(', '[', '{', '=', '\\', '"', '\'', '<CR>'}) do
   map('i', c, c .. "<C-g>u", { noremap = true })
end

-- keep visual selection when (de)indenting
map('v', '<', '<gv', {})
map('v', '>', '>gv', {})

-- Move selected lines up/down in visual mode
--map('x', 'K', ":move '<-2<CR>gv=gv", {})
--map('x', 'J', ":move '>+1<CR>gv=gv", {})

-- Keep matches center screen when cycling with n|N
map('n', 'n', 'nzzzv', {})
map('n', 'N', 'Nzzzv', {})

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

-- command line key bindings {{{2

-- Beginning and end of line in `:` command mode
map('c', '<C-s>', '<home>', {})
map('c', '<C-e>', '<end>' , {})

-- Arrows in command line mode (':') menus
map('c', '<down>', '(wildmenumode() ? "\\<C-n>" : "\\<down>")', { expr = true })
map('c', '<up>',   '(wildmenumode() ? "\\<C-p>" : "\\<up>")',   { expr = true })
for k, v in pairs({ ['<down>'] = '<C-n>', ['<up>'] = '<C-p>' }) do
 map('c', k, function()
   return vim.fn.wildmenumode() and v or k
 end, {expr=true})
end

-- not sure what this does
-- overloads for 'd|c' that don't pollute the unnamed registers
-- map('n', '<leader>D',  '"_D',         {})
-- map('n', '<leader>C',  '"_C',         {})
-- map({'n', 'v'}, '<leader>c',  '"_c',  {})

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

-- terminal mappings {{{2

-- switch to normal mode
map('t', '<M-[>', [[<C-\><C-n>]], {})

-- paste any register into a terminal with Alt-p <register>
map('t', '<A-p>', [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })

-- navigation {{{2

-- navigate buffers {{{3
map('n', '<leader><tab><s-tab>', ':tabprevious<CR>', {})
map('n', '<leader><tab><tab>',   ':tabnext<CR>',     {})
map('n', '<leader><tab>f',       ':tabfirst<CR>',    {})
map('n', '<leader><tab>l',       ':tablast<CR>',     {})
map('n', '<Leader><tab>n',       ':tabnew<CR>',      {})
map('n', '<Leader><tab>c',       ':tabclose<CR>',    {})
map('n', '<Leader><tab>o',       ':tabonly<CR>',     {})
map('n', '<Leader><tab>z',       function() utils.tabz() end,     {})

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

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

map({'t', 'i'}, '<C-h>', '<C-\\><C-N><C-w>h')
map({'t', 'i'}, '<C-j>', '<C-\\><C-N><C-w>j')
map({'t', 'i'}, '<C-k>', '<C-\\><C-N><C-w>k')
map({'t', 'i'}, '<C-l>', '<C-\\><C-N><C-w>l')

-- split resize with tmux-like directional resizes
map({'n', 't', 'i'}, '<A-k>', function() utils.relative_resize(false, -2) end, { silent = true })
map({'n', 't', 'i'}, '<A-j>', function() utils.relative_resize(false,  2) end, { silent = true })
map({'n', 't', 'i'}, '<A-h>', function() utils.relative_resize(true,  -2) end, { silent = true })
map({'n', 't', 'i'}, '<A-l>', function() utils.relative_resize(true,   2) end, { silent = true })

-- unimpaired-like mappings {{{2

-- diagnostic list mappings
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

-- quickfix list mappings
--map('n', '<leader>q', "<cmd>lua require'utils'.toggle_qf('q')<CR>", {})
-- map('n', '[q', ':cprevious<CR>',      {})
-- map('n', ']q', ':cnext<CR>',          {})
-- map('n', '[Q', ':cfirst<CR>',         {})
-- map('n', ']Q', ':clast<CR>',          {})

-- location list mappings
--map('n', '<leader>Q', "<cmd>lua require'utils'.toggle_qf('l')<CR>", {})
-- map('n', '[l', ':lprevious<CR>',      {})
-- map('n', ']l', ':lnext<CR>',          {})
-- map('n', '[L', ':lfirst<CR>',         {})
-- map('n', ']L', ':llast<CR>',          {})


-- old and unused key bindings {{{2

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
