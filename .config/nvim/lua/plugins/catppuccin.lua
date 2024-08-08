-- catppuccin/nvim
-- catppuccin for (Neo)vim
return {
  'catppuccin/nvim',
  lazy = false,
  name = 'catppuccin',
  priority = 1000,
  config = function()
    require'catppuccin'.setup {
      flavour = "macchiato", -- auto, latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "macchiato",
        dark = "mocha",
      },
      transparent_background = true, -- disables setting the background color.
      show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
      term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = 'dark',
        percentage = 0.01, -- percentage of the shade to apply to the inactive window
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { 'italic' }, -- Change the style of comments
        conditionals = { 'italic' },
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
          -- NormalNC = { bg = colors.mantle },
          Folded = { bg = 'NONE' },
          TermCursorNC = { fg = colors.base, bg = colors.subtext0 },
          VirtColumn = { fg = colors.surface0 },
          FoldColumn = { fg = colors.blue },
          CursorColumn = { bg = '#303347' },
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
      },
    }
    vim.cmd.colorscheme "catppuccin"
  end

}
