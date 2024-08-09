local aucmd = vim.api.nvim_create_autocmd

local function augroup(name, fnc)
  fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

augroup('NewlineNoAutoComments', function(g)
  aucmd('FileType', {
    group = g,
    pattern = '*',
    command = 'setlocal formatoptions-=o'
  })
end)

augroup('keywordprg', function(g)
  aucmd('FileType', {
    group = g,
    pattern = {'sh', 'bash', 'zsh'},
    command = 'lua vim.o.keywordprg = ":Man"'
  })
end)

-- remove search highlights while in insert mode
augroup('ToggleSearchHL', function(g)
  aucmd('InsertEnter',
  {
    group = g,
    pattern = '*',
    command = ':nohl | redraw'
  })
end)

-- hide line numbers  in terminal mode
augroup('TermOptions', function(g)
  aucmd('TermOpen',
  {
    group = g,
    pattern = '*',
    command = 'setlocal listchars= nonumber norelativenumber | exec "normal! i"'
  })
end)

-- different folding methods for different files 
augroup('FoldingMethods', function(g)
  aucmd( {'BufEnter', 'BufWinEnter'} ,
  {
    group = g,
    pattern = {'init.lua', '.zshrc'},
    command = 'setlocal foldmethod=marker',
  })
end)
