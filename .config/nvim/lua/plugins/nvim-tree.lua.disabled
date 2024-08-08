-- nvim-tree/nvim-tree.lua {{{2
-- A File Explorer For Neovim Written In Lua
return {
  { 'nvim-tree/nvim-tree.lua',
    version = '*',
    keys = {
      { '<leader>ft', mode = { 'n', 'v' } },
    },
    config = function()
      require('nvim-tree').setup {
        disable_netrw = true,
        hijack_cursor = true,
        hijack_netrw = false,
        update_cwd = true,
        view = {
          width = 40,
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
            hint = " ",
            info = " ",
            warning = " ",
            error = " ",
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
    end,
  },
}
