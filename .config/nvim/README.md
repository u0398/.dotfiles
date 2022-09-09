# My nvim-lua setup

![screenshot](https://github.com/ibhagwan/nvim-lua/raw/main/screenshot.png)

## What's in this repo?

**My personal neovim lua config (requires neovim >= `0.7`)**

- Minimum changes to default key mapping
- A good selection of carefully hand-picked plugins
- Lazy load plugins where possible
- Which-key to rule them all
- Misc utilities and goodies

## Plugins

- [packer.nvim](https://github.com/wbthomason/packer.nvim): lua plugin
  manager to auto-install and update our plugins

### Basics

- [mini.surround](https://github.com/echasnovski/mini.nvim): adds the missing
  operators (`ds`, `cs`, `ys`) for dealing with pairs of "surroundings"
  (quotes, tags, etc)

### Git

- [vim-fugitive](https://github.com/tpope/vim-fugitive): git porcelain and
  plumbing in one by tpope, the Swiss army knife of git

- [gitsigns](https://github.com/lewis6991/gitsigns.nvim): git gutter indicators
  and hunk management

### Coding, completion & LSP

- [Comment.nvim](https://github.com/numToStr/Comment.nvim): use `gc` and
  `gcc` to comment visual-blocks and lines

- [mini.indentscope](https://github.com/echasnovski/mini.nvim):
  add indentation markers based on `tabstop | shiftwidth`

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp): autocompletion framework

- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter): text
  parsing library, provides better syntax highlighting and text-objects for
  different coding languages (e.g. `yaf` yank-a-function), see
  [treesitter.lua](https://github.com/ibhagwan/nvim-lua/blob/main/lua/plugins/treesitter.lua)
  for defined text objects

- [lspconfig](https://github.com/neovim/nvim-lspconfig): configuration
  quickstart for nvim's built in LSP

- [nvim-lsp-installer](https://github.com/williamboman/nvim-lsp-installer):
  automatic installation of LSP servers using the `:LspInstall` command

- [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim): a lua
  in-memory pseudo LSP server providing custom functionalities via the Neovim
  LSP API, provides spelling word completion and lua code formatting using
  [`stylua`](https://github.com/JohnnyMorganz/StyLua)

- [nvim-dap](https://github.com/mfussenegger/nvim-dap):
  set breakpoints and debug applications using Debug Adapter Protocol (DAP)

- [fidget.nvim](https://github.com/j-hui/fidget.nvim): Eye candy LSP progress
  indicator above the status line (top right)

### Fuzzy search & file exploration

- [fzf-lua](https://github.com/ibhagwan/fzf-lua): the original, tried and
  tested fuzzy finder, lua plugin that does pretty much everything, written by
  yours truly

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim): fuzzy
  search framework for searching project files, buffers, ripgrep and much more

- [nvim-tree](https://github.com/kyazdani42/nvim-tree.lua): file-explorer tree

- [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf): better quickfix and
  location list, provides quickfix previews, history and fuzzy search, great
  companion for both telescope and fzf after sending search results to a list

### Misc

- [which-key](https://github.com/folke/which-key.nvim): a must plugin in every
  setup, when leader key (and some built-ins) sequence is pressed and times out
  which-key will generate a help window with your keybinds and also let you
  continue the sequence at your own pace

- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim): better term and
  REPLs (use `gx` and `gxx` to send REPLs to an interpreter)

- [oscyank](https://github.com/ojroques/vim-oscyank): copy text over ssh
  terminals using `OSC52`

- [nvim-reload](https://github.com/famiu/nvim-reload): properly reload your
  nvim configuration and lua modules with `<space>R`

- [previm](https://github.com/previm/previm): live preview markdown files in
  the browser with `<space>r`

### Appearence

- [express\_line](https://github.com/tjdevries/express_line.nvim):
  [TJ's](https://github.com/tjdevries) status line plugin, customized and
  highlighted by me and, LSP/diag patched to work on any neovim >= 0.5

- [nvcode-color-schemes](https://github.com/christianchiarulli/nvcode-color-schemes.vim):
  a collection of treesitter compatible color schemes

- [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua): color
  code highlighter, use `ColorizerAttachToBuffer` to provide a live preview of
  color codes in your buffer (e.g. `#d4bfff`)
