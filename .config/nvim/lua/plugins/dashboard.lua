-- nvimdev/dashboard-nvim
-- fancy and blazing Fast start screen plugin of neovim
return {
  { 'nvimdev/dashboard-nvim',
    lazy = false,
    opts = function()
      local header = ''
      local preview = {}
      local logo = [[
            .d8888b.   .d8888b.   .d8888b.   .d8888b.        
           d88P  Y88b d88P  Y88b d88P  Y88b d88P  Y88b       
           888    888      .d88P 888    888 Y88b. d88P       
  888  888 888    888     8888"  Y88b. d888  "Y88888"        
  888  888 888    888      "Y8b.  "Y888P888 .d8P""Y8b.       
  888  888 888    888 888    888        888 888    888       
  Y88b 888 Y88b  d88P Y88b  d88P Y88b  d88P Y88b  d88P       
  "Y88888  "Y8888P"   "Y8888P"   "Y8888P"   "Y8888P"         
  888b    888                  888     888 d8b               
  8888b   888                  888     888 Y8P               
  88888b  888                  888     888                   
  888Y88b 888  .d88b.   .d88b. Y88b   d88P 888 88888b.d88b.  
  888 Y88b888 d8P  Y8b d88""88b Y88b d88P  888 888 "888 "88b 
  888  Y88888 88888888 888  888  Y88o88P   888 888  888  888 
  888   Y8888 Y8b.     Y88..88P   Y888P    888 888  888  888 
  888    Y888  "Y8888   "Y88P"     Y8P     888 888  888  888 ]]

      logo = string.rep("\n", 4) .. logo .. "\n\n"

      -- if lolcrab is installed use preview to make the logo colorful, otherwise use header
      if vim.fn.executable('lolcrab') == 1 then
        preview = {
          command = "echo '".. logo .."' | lolcrab -c f3dbd6 f0c6c6 f5bde6 c6a0f6 ed8796 ee99a0 f5a97f eed49f a6da95 8bd5ca 91d7e3 7dc4e4 8aadf4 b7bdf8",
          file_path = '',
          file_height = 22,
          file_width = 61,
        }
      else
        header = string.gsub(logo,"\n ","\n")
        header = string.rep("\n", 4) .. header
      end

      local opts = {
        theme = "doom",
        hide = {
          statusline = true, -- this is taken care of by heirline
        },
        preview = preview,
        config = {
          header = vim.split(header, "\n"),
          center = {
            { action = function() require'telescope' vim.cmd("Telescope find_files") end,
              desc = " Find File", icon = "󰍉 ", key = "f"
            },
            { action = "ene | startinsert",
              desc = " New File", icon = " ", key = "n"
            },
            { action = function() require'telescope' vim.cmd("Telescope oldfiles") end,
              desc = " Recent Files", icon = " ", key = "r"
            },
            { action = function() require'telescope' vim.cmd('Telescope live_grep') end,
              desc = " Find Text", icon = "󰦨 ", key = "g"
            },
            { action = function() vim.api.nvim_input('<cmd>:SessionSearch<cr>') end,
              desc = " Load Session", icon = " ", key = "s"
            },
            { action = "Lazy",
              desc = " Lazy", icon = "󰒲 ", key = "l"
            },
            { action = function() vim.api.nvim_input("<cmd>qa<cr>") end,
              desc = " Quit", icon = " ", key = "q"
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end
      return opts
    end,
  },
}
