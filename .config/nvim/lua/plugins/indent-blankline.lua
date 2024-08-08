-- lukas-reineke/indent-blankline.nvim
-- adds indentation guides to Neovim
return {
  "lukas-reineke/indent-blankline.nvim",
  event = "VeryLazy",
  opts = function()
    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "ibl_bright_red", { fg = "#9d6171" })
      vim.api.nvim_set_hl(0, "ibl_bright_peach", { fg = "#a17563" })
      vim.api.nvim_set_hl(0, "ibl_bright_yellow", { fg = "#9d8f77" })
      vim.api.nvim_set_hl(0, "ibl_bright_green", { fg = "#729271" })
      vim.api.nvim_set_hl(0, "ibl_bright_teal", { fg = "#628f90" })
      vim.api.nvim_set_hl(0, "ibl_bright_sapphire", { fg = "#5985a0" })
      vim.api.nvim_set_hl(0, "ibl_bright_lavender", { fg = "#7c81ac" })
      vim.api.nvim_set_hl(0, "ibl_red", { fg = "#604455" })
      vim.api.nvim_set_hl(0, "ibl_peach", { fg = "#624e4f" })
      vim.api.nvim_set_hl(0, "ibl_yellow", { fg = "#605b58" })
      vim.api.nvim_set_hl(0, "ibl_green", { fg = "#4b5c55" })
      vim.api.nvim_set_hl(0, "ibl_teal", { fg = "#435b65" })
      vim.api.nvim_set_hl(0, "ibl_sapphire", { fg = "#3f566d" })
      vim.api.nvim_set_hl(0, "ibl_lavender", { fg = "#505473" })
    end)

    local highlight = {
      "ibl_red",
      "ibl_peach",
      "ibl_yellow",
      "ibl_green",
      "ibl_teal",
      "ibl_sapphire",
      "ibl_lavender",
    }
    local highlight_bright = {
      "ibl_bright_red",
      "ibl_bright_peach",
      "ibl_bright_yellow",
      "ibl_bright_green",
      "ibl_bright_teal",
      "ibl_bright_sapphire",
      "ibl_bright_lavender",
    }

    return {
      indent = {
        char = "│",
        tab_char = "│",
        highlight = highlight,
      },
      debounce = 100,
      whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
      },
      scope = {
        enabled = true,
        char = '│',
        show_start = false,
        show_end = false,
        highlight = highlight_bright,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    }
  end,
  main = "ibl",
}

