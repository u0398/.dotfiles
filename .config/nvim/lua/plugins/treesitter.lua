-- nvim-treesitter/nvim-treesitter
-- Improved tree-sitter hilighting
return {
  'nvim-treesitter/nvim-treesitter',
  version = false,
  build = ':TSUpdate',
  event = { 'VeryLazy' },
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treesitter** module to be loaded in time.
    -- Luckily, the only things that those plugins need are the custom queries, which we make available
    -- during startup.
    require('lazy.core.loader').add_to_rtp(plugin)
    require('nvim-treesitter.query_predicates')
  end,
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  keys = {
    { '<c-space>', desc = 'Increment Selection' },
    { '<bs>', desc = 'Decrement Selection', mode = 'x' },
  },
  opts_extend = { "ensure_installed" },
  opts = {
    highlight = {
      enable = true,
      disable = {
        -- "c", "cpp",
        -- ugly for markdown
        "md", "markdown",
      },
    },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
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
    textobjects = {
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]tm"] = "@function.outer",
          ["]tf"] = "@call.outer",
          ["]tc"] = "@class.outer",
          ["]ta"] = "@parameter.inner",
          ["]ti"] = "@conditional.outer",
          ["]tl"] = "@loop.outer",
        },
        goto_next_end = {
          ["]tM"] = "@function.outer",
          ["]tF"] = "@call.outer",
          ["]tC"] = "@class.outer",
          ["]tA"] = "@parameter.inner",
          ["]tI"] = "@conditional.outer",
          ["]tL"] = "@loop.outer",
        },
        goto_previous_start = {
          ["[tm"] = "@function.outer",
          ["[tf"] = "@call.outer",
          ["[tc"] = "@class.outer",
          ["[ta"] = "@parameter.inner",
          ["[ti"] = "@conditional.outer",
          ["[tl"] = "@loop.outer",
        },
        goto_previous_end = {
          ["[tM"] = "@function.outer",
          ["[tF"] = "@call.outer",
          ["[tC"] = "@class.outer",
          ["[tA"] = "@parameter.inner",
          ["[tI"] = "@conditional.outer",
          ["[tL"] = "@loop.outer",
        },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,

}
