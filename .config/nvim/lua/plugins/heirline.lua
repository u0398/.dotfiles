-- rebelot/heirline.nvim {{{2
-- the ultimate Neovim Statuslie for tinkerers
return {
  { 'rebelot/heirline.nvim',
    init = function()
      local heir_conditions = require("heirline.conditions")
      local heir_utils = require("heirline.utils")

      -- apply colors from the color scheme palette to a semantic color table
      local colorscheme_colors = require("catppuccin.palettes").get_palette "macchiato"
      local heir_colors = {
        mode_normal    = colorscheme_colors.blue,
        mode_insert    = colorscheme_colors.green,
        mode_visual    = colorscheme_colors.mauve,
        mode_command   = colorscheme_colors.peach,
        mode_select    = colorscheme_colors.pink,
        mode_replace   = colorscheme_colors.peach,
        mode_executing = colorscheme_colors.red,
        mode_terminal  = colorscheme_colors.yellow,

        statusline                   = 'NONE',
        statusline_inactive          = 'NONE',
        -- statusline           = colorscheme_colors.base,
        -- statusline_inactive  = colorscheme_colors.mantle,
        bg                   = colorscheme_colors.surface0,
        bg_inactive          = colorscheme_colors.surface0,
        text                 = colorscheme_colors.text,
        text_inactive        = colorscheme_colors.surface2,
        prefix               = colorscheme_colors.surface2,
        prefix_inactive      = colorscheme_colors.surface2,
        prefix_text          = colorscheme_colors.base,
        prefix_text_inactive = colorscheme_colors.base,

        file_name         = colorscheme_colors.green,
        file_name_locked  = colorscheme_colors.peach,
        help              = colorscheme_colors.green,
        diagnostics       = colorscheme_colors.flamingo,
        git               = colorscheme_colors.teal,
        git_added         = colorscheme_colors.green,
        git_removed       = colorscheme_colors.red,
        git_changed       = colorscheme_colors.yellow,
        git_parenthese    = colorscheme_colors.overlay0,
        file_properties   = colorscheme_colors.mauve,
        buff              = colorscheme_colors.blue,
        buff_active       = colorscheme_colors.peach,
        buff_text         = colorscheme_colors.subtext0,
        buff_text_active  = colorscheme_colors.text,
        tab               = colorscheme_colors.teal,
        tab_text          = colorscheme_colors.subtext0,
        tab_text_active   = colorscheme_colors.teal,

        ERROR = colorscheme_colors.red,
        WARN  = colorscheme_colors.peach,
        INFO  = colorscheme_colors.yellow,
        HINT  = colorscheme_colors.teal,
      }

      local heir_block_prefix = { provider = '' }
      local heir_block_suffix = { provider = '' }
      local heir_block_spacer = { provider = ' ' }

      local heir_block_suffix_modifier = {
        hl = function()
          if heir_conditions.is_active() then
            return { fg = 'bg', bg = 'statusline' }
          else
            return { fg = 'bg_inactive', bg = 'statusline_inactive' }
          end
        end
      }

      local heir_block_prefix_raw = heir_utils.insert( heir_block_prefix )
      local heir_block_suffix_raw = heir_utils.insert( heir_block_suffix )

      heir_block_suffix = heir_utils.insert( heir_block_suffix_modifier, heir_block_suffix )
      heir_block_suffix = heir_utils.insert( heir_block_suffix_modifier, heir_block_suffix )

      local heir_mode = {
        init = function(self)
          self.mode = vim.fn.mode(1)
        end,
        static = {
          mode_names = {
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
          },
        },
        provider = function(self)
          return "%2("..self.mode_names[self.mode].." %)"
        end,
        update = {
          'WinEnter',
          'WinLeave',
          'ModeChanged',
          -- !!! intended for entering operator-pending mode, but breaks inactive settings
          -- pattern = "*:*",
          -- callback = vim.schedule_wrap(function()
          --   vim.cmd("redrawstatus")
          -- end),
        },
      }

      local heir_mode_modifier = {
        hl = function(self)
          if heir_conditions.is_active() then
            local color = self:mode_color()
            return { fg = 'prefix_text', bg = color, bold = true }
          else
            return { fg = 'prefix_text', bg = 'prefix_inactive', bold = true }
          end
        end,
      }

      heir_mode = heir_utils.insert( heir_mode_modifier, heir_mode )

      local heir_mode_prefix_modifier = {
        -- condition = heir_conditions.is_active(),
        hl = function(self)
          if heir_conditions.is_active() then
            local color = self:mode_color()
            return { fg = color }
          else
            return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
          end
        end,
      }

      local heir_mode_prefix = heir_utils.insert(heir_mode_prefix_modifier, heir_block_prefix)

      heir_mode = heir_utils.insert( heir_mode_prefix, heir_mode )

      local heir_file_path = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
          --self.filename = vim.fn.expand("%:t")
        end,
        hl = function()
          if heir_conditions.is_active() then
            return { fg = 'text', bg = 'bg' }
          else
            return { fg = 'text_inactive', bg = 'bg_inactive' }
          end
        end,
      }

      local heir_file_name = {
        provider = function(self)
          local filename = vim.fn.fnamemodify(self.filename, ":.")
          if filename == "" then return ' [No Name]' end
          if not heir_conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
          end
          return ' ' .. filename
        end,
      }

      local heir_file_name_flags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = '+',
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'file_name' }
            else
              return { fg = 'text_inactive' }
            end
        end,
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = '  ',
          hl = { fg = 'file_name_locked' },
        },
      }

      local heir_file_name_modifier = {
        hl = function()
          if vim.bo.modified and heir_conditions.is_active() then
            return { fg = 'file_name', bold = true, force=true }
          end
        end,
      }

      heir_file_path = heir_utils.insert(
        heir_file_path,
        heir_utils.insert(heir_file_name_modifier, heir_file_name),
        { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
      )

      heir_file_path = heir_utils.insert(
        heir_file_path,
        heir_file_name_flags,
        heir_block_suffix
      )

      local heir_help_file_prefix_modifier = {
        hl = function()
          if heir_conditions.is_active() then
            return { fg = 'help', bg = 'statusline' }
          else
            return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
          end
        end
      }

      local heir_help_file_prefix = {
        heir_utils.insert(heir_help_file_prefix_modifier, heir_block_prefix)
      }

      local heir_help_file = {
        { provider = '󰘥 ',
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'prefix_text', bg = 'help' }
            else
              return { fg = 'prefix_text_inactive', bg = 'prefix_inactive' }
            end
          end
        },
        { provider = function()
            local filename = vim.api.nvim_buf_get_name(0)
            return ' ' .. vim.fn.fnamemodify(filename, ":t")
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'text', bg = 'bg' }
            else
              return { fg = 'text_inactive', bg = 'bg_inactive' }
            end
          end
        },
      }

      heir_help_file = heir_utils.insert(
        heir_help_file_prefix,
        heir_help_file,
        heir_block_suffix
      )

      local heir_terminal_name = {
        { provider = function()
            local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
            return " " .. tname
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'text', bg = 'bg' }
            else
              return { fg = 'prefix_text_inactive', bg = 'bg_inactive' }
            end
          end
        },
        heir_block_suffix
      }

      local heir_diagnostics_modifier = {
        condition = heir_conditions.has_diagnostics,
      }
      local heir_diagnostics_prefix_modifier = {
        hl = function()
          if heir_conditions.is_active() then
            return { fg = 'diagnostics', bg = 'statusline' }
          else
            return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
          end
        end
      }

      local heir_diagnostics_spacer = heir_utils.insert(heir_diagnostics_modifier, heir_block_spacer)

      local heir_diagnostics_prefix = {
        heir_utils.insert(heir_diagnostics_prefix_modifier, heir_block_prefix)
      }

      local heir_diagnostics = {
        init = function(self)
          self.error_num = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warn_num = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hint_num = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info_num = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,
        update = { "DiagnosticChanged", "BufEnter", "WinEnter", 'WinLeave' },
        hl = { fg = 'text_inactive', bg = 'bg_inactive' },

        { provider = ' ',
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'prefix_text', bg = 'diagnostics' }
            else
              return { fg = 'prefix_text_inactive', bg = 'prefix_inactive' }
            end
          end
        },
        { provider = function(self) return self.error_num > 0 and
            (' ' .. self.error_num)
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'ERROR', bg = 'bg' }
            end
          end
        },
        { provider = function(self) return self.warn_num > 0 and
            (' ' .. self.warn_num)
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'WARN', bg = 'bg' }
            end
          end
        },
        { provider = function(self) return self.info_num > 0 and
            (' ' .. self.info_num)
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'INFO', bg = 'bg' }
            end
          end
        },
        { provider = function(self) return self.hint_num > 0 and
            (' ' .. self.hint_num)
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'HINT', bg = 'bg' }
            end
          end
        },
      }

      heir_diagnostics = heir_utils.insert(
        heir_diagnostics_modifier,
        heir_diagnostics_prefix,
        heir_diagnostics,
        heir_block_suffix
      )
      local heir_ruler_prefix_modifier = {
        hl = function(self)
          if heir_conditions.is_active() then
            local color = self:mode_color()
            return { fg = color, bg = 'statusline' }
          else
            return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
          end
        end,
      }

      local heir_ruler_prefix = heir_utils.insert(
        heir_ruler_prefix_modifier,
        heir_block_prefix
      )

      local heir_ruler = {
        { provider = '󰮱 ',
          hl = function(self)
            if heir_conditions.is_active() then
              local color = self:mode_color()
              return { fg = 'prefix_text', bg = color }
            else
              return { fg = 'prefix_text_inactive', bg = 'prefix_inactive' }
            end
          end,
        },
        { provider = ' %(%l/%L%):%c',
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'text', bg = 'bg' }
            else
              return { fg = 'text_inactive', bg = 'bg_inactive' }
            end
          end,
        },
      }

      heir_ruler = heir_utils.insert(
        heir_ruler_prefix,
        heir_ruler,
        heir_block_suffix
      )

      local heir_git_modifier = {
        condition = heir_conditions.is_git_repo,
      }

      local heir_git_spacer = heir_utils.insert(
        heir_git_modifier,
        heir_block_spacer
      )

      local heir_git_prefix_modifier = {
        hl = function()
          if heir_conditions.is_active() then
            return { fg = 'git', bg = 'statusline' }
          else
            return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
          end
        end
      }

      local heir_git_prefix = heir_utils.insert(
        heir_git_prefix_modifier,
        heir_block_prefix
      )

      local heir_git = {
        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes =
            self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
        end,
        hl = { fg= 'text_inactive', bg  = 'bg_inactive' },

        { provider = ' ',
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'prefix_text', bg = 'git' }
            else
              return { fg = 'prefix_text_inactive', bg = 'prefix_inactive' }
            end
          end,
        },
        { provider = function(self)
            return ' ' .. self.status_dict.head
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'text', bg = 'bg' }
            end
          end,
        },
        { condition = function(self)
            return self.has_changes
          end,
          provider = "(",
          hl = { fg = 'git_parenthese', bg = 'bg' }
        },
        { provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'git_added', bg = 'bg' }
            end
          end,
        },
        { provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'git_removed', bg = 'bg' }
            end
          end,
        },
        { provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'git_changed', bg = 'bg' }
            end
          end,
        },
        { condition = function(self)
            return self.has_changes
          end,
          provider = ")",
          hl = { fg = 'git_parenthese', bg = 'bg' }
        },
      }

      heir_git = heir_utils.insert(
        heir_git_modifier,
        heir_git_prefix,
        heir_git,
        heir_block_suffix
      )

      local heir_file_properties_prefix_modifier = {
        hl = function()
          if heir_conditions.is_active() then
            return { fg = 'file_properties', bg = 'statusline' }
          else
            return { fg = 'prefix_inactive', bg = 'statusline_inactive' }
          end
        end
      }
      local heir_file_properties_prefix = heir_utils.insert(
        heir_file_properties_prefix_modifier,
        heir_block_prefix
      )

      local heir_file_properties = {
        hl = { fg = 'text_inactive', bg  = 'bg_inactive' },

        { provider = '󰱽 ',
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'prefix_text', bg = 'file_properties' }
            else
              return { fg = 'prefix_text_inactive', bg = 'prefix_inactive' }
            end
          end,
        },
        { provider = function()
            return ' ' .. string.upper(vim.bo.filetype)
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'text', bg = 'bg' }
            end
          end,
        },
        {
          provider = function()
            local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
            if enc ~= 'utf-8' then
              return ' ' .. enc:upper()
            end
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'text', bg = 'bg' }
            end
          end,
        },
        {
          provider = function()
            local fmt = vim.bo.fileformat
            if fmt ~= 'unix' then
              return ' ' .. fmt:upper()
            end
          end,
          hl = function()
            if heir_conditions.is_active() then
              return { fg = 'text', bg = 'bg' }
            end
          end,
        },
      }

      local heir_file_properties_modifier = {
        condition = function()
          local ft = vim.bo.filetype
          local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
          local fmt = vim.bo.fileformat
          if ft == '' and enc == 'utf-8' and fmt == 'unix' then
            return false
          else
            return true
          end
        end,
      }

      local heir_tab_buffer_num = {
        provider = function(self)
          return tostring(self.bufnr) .. ' '
        end,
        hl = function(self)
          if self.is_active then
            return { fg = 'prefix_text', bg = 'buff_active' }
          else
            return { fg = 'prefix_text', bg = 'buff' }
          end
        end
      }

      local heir_tab_file_name = {
        provider = function(self)
          -- self.filename will be defined later, just keep looking at the example!
          local filename = self.filename
          filename = filename == '' and ' [No Name]' or vim.fn.fnamemodify(filename, ":t")
          return ' ' .. filename
        end,
        hl = function(self)
          if vim.api.nvim_get_option_value('modified', { buf = self.bufnr }) then
            return { fg = 'file_name' }
          end
        end,
      }

      local heir_tab_file_name_flags = {
        { condition = function(self)
          return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
        end,
        provider = '+',
        hl = { fg = 'file_name' },
        },
        { condition = function(self)
            return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
                    or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
          end,
          provider = '  ',
          hl = { fg = "file_name_locked" },
        },
      }

      local heir_tab_buf_prefix_modifier = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(self.bufnr)
        end,
        hl = function(self)
          if self.is_active then
            return { fg = 'buff_active', bg = 'statusline' }
          else
            return { fg = 'buff', bg = 'statusline_inactive' }
          end
        end
      }

      local heir_tab_buf_prefix = {
        heir_utils.insert(heir_tab_buf_prefix_modifier, heir_block_prefix)
      }

      local heir_tab_close_btn = {
        condition = function(self)
          return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
        end,
        { provider = ' ' },
        { provider = '',
          hl = { fg = 'text_inactive' },
          on_click = {
            callback = function(_, minwid)
              vim.schedule(function()
                vim.api.nvim_buf_delete(minwid, { force = false })
                vim.cmd.redrawtabline()
              end)
            end,
            minwid = function(self)
              return self.bufnr
            end,
            name = "heirline_tabline_close_buffer_callback",
          },
        },
      }

      local heir_tab_buf_suffix_modifier = {
        hl = function(self)
          if self.is_active then
            return { fg = 'bg', bg = 'statusline' }
          else
            return { fg = 'bg_inactive', bg = 'statusline_inactive' }
          end
        end
      }

      local heir_tab_buf_suffix = heir_utils.insert( heir_tab_buf_suffix_modifier, heir_block_suffix_raw, heir_block_spacer )


      local heir_tab_buf = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(self.bufnr)
        end,
        hl = function(self)
          if self.is_active then
            return { fg = 'buff_text_active', bg = 'bg' }
          else
            return { fg = 'buff_text', bg = 'bg_inactive' }
          end
        end,
        on_click = {
          callback = function(_, minwid, _, button)
            if (button == "m") then -- close on mouse middle click
              vim.schedule(function()
                vim.api.nvim_buf_delete(minwid, { force = false })
              end)
            else
              vim.api.nvim_win_set_buf(0, minwid)
            end
          end,
          minwid = function(self)
            return self.bufnr
          end,
          name = "heirline_tabline_buffer_callback",
        },
        heir_tab_buf_prefix,
        heir_tab_buffer_num,
        heir_tab_file_name,
        heir_tab_file_name_flags,
        heir_tab_close_btn,
        heir_tab_buf_suffix,
      }
      local buflist_cache = {}

      local get_bufs = function()
        return vim.tbl_filter(function(bufnr)
          return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
        end, vim.api.nvim_list_bufs())
      end


      vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            local buffers = get_bufs()
            for i, v in ipairs(buffers) do
              buflist_cache[i] = v
            end
            for i = #buffers + 1, #buflist_cache do
              buflist_cache[i] = nil
            end
            -- check how many buffers we have and set showtabline accordingly
            -- if #buflist_cache > 1 then
            --   vim.o.showtabline = 2 -- always
            -- elseif vim.o.showtabline ~= 1 then -- don't reset the option if it's already at default value
            --   vim.o.showtabline = 1 -- only when #tabpages > 1
            -- end
          end)
        end,
      })

      local heir_buffer_line = heir_utils.make_buflist(
        heir_tab_buf,
        { provider = " ", hl = { fg = "buff" } },
        { provider = " ", hl = { fg = "buff" } },
        -- out buf_func simply returns the buflist_cache
        function()
          return buflist_cache
        end,
        -- no cache, as we're handling everything ourselves
        false
      )

      local heir_tab_page_prefix_modifier = {
        hl = { fg = 'tab', bg = 'statusline' }
      }

      local heir_tab_page_prefix = {
        heir_utils.insert(heir_tab_page_prefix_modifier, heir_block_prefix)
      }

      local heir_tab_page = {
        provider = function(self)
          if ( self.tabnr == vim.fn.tabpagenr('$') ) then
            return "%" .. self.tabnr .. "T" .. self.tabpage .. "%T"
          else
            return "%" .. self.tabnr .. "T" .. self.tabpage .. " %T"
          end
        end,
        hl = function(self)
          if not self.is_active then
            return { fg = "tab_text" }
          else
            return { fg = "tab_text_active" }
          end
        end,
      }

      local heir_tab_pages = {
        -- only show this component if there's 2 or more tabpages
        condition = function()
          return #vim.api.nvim_list_tabpages() >= 2
        end,
        hl = { bg = 'bg' },
        heir_tab_page_prefix,
        { provider = '󰓩 ',
          hl = { fg = 'prefix_text', bg = 'tab' },
        },
        { provider = ' ' },
        heir_utils.make_tablist( heir_tab_page ),
        heir_block_suffix,
      }

      local heir_tab_line_offset = {
        condition = function(self)
          local win = vim.api.nvim_tabpage_list_wins(0)[1]
          local bufnr = vim.api.nvim_win_get_buf(win)
          self.winid = win

          if vim.bo[bufnr].filetype == "NvimTree" then
            self.title = "NvimTree"
            return true
          end
        end,

        provider = function(self)
          local title = self.title
          local width = vim.api.nvim_win_get_width(self.winid)
          local pad = math.ceil((width - #title) / 2)
          return string.rep(" ", pad) .. title .. string.rep(" ", pad)
        end,

        hl = function(self)
          if vim.api.nvim_get_current_win() == self.winid then
            return "buff_active"
          else
            return "buff"
          end
        end,
      }

      local heir_alignment = {
        provider = '%='
      }

      local heir_tabline = {
        heir_tab_line_offset,
        heir_buffer_line,
        heir_alignment,
        heir_tab_pages
      }

      local heir_file_properties_spacer = heir_utils.insert(
        heir_file_properties_modifier,
        heir_block_spacer
      )

      heir_file_properties = heir_utils.insert(
        heir_file_properties_modifier,
        heir_file_properties_prefix,
        heir_file_properties,
        heir_block_suffix
      )

      local heir_default_statusline = {
        heir_mode,
        heir_file_path,
        heir_diagnostics_spacer,
        heir_diagnostics,
        heir_alignment,
        heir_file_properties,
        heir_file_properties_spacer,
        heir_git,
        heir_git_spacer,
        heir_ruler
      }
      local heir_blank_statusline = {
        condition = function()
          return heir_conditions.buffer_matches {
            buftype = { 'nofile', 'prompt', 'quickfix' },
            filetype = { '^git.*', 'dashboard', 'fugitive' },
          }
        end,
      }

      local heir_help_statusline = {
        condition = function()
          return heir_conditions.buffer_matches {
            buftype = { 'help' },
          }
        end,
        heir_help_file,
        heir_alignment,
        heir_ruler
      }

      local heir_terminal_statusline = {
        condition = function()
          return heir_conditions.buffer_matches {
            buftype = { 'terminal' },
          }
        end,
        heir_mode,
        heir_terminal_name,
        heir_alignment,
        heir_ruler
      }

      local heir_statusline = {
        hl = { fg = 'NONE', bg = 'NONE' },
        fallthrough = false,

        heir_help_statusline,
        heir_terminal_statusline,
        heir_blank_statusline,
        heir_default_statusline,

        static = {
          mode_colors_map = {
            n       = 'mode_normal',
            i       = 'mode_insert',
            v       = 'mode_visual',
            V       = 'mode_visual',
            ["\22"] = 'mode_visual',
            c       = 'mode_command',
            s       = 'mode_select',
            S       = 'mode_select',
            ["\19"] = 'mode_select',
            R       = 'mode_replace',
            r       = 'mode_replace',
            ["!"]   = 'mode_executing',
            t       = 'mode_terminal',
          },
          mode_color = function(self)
            local m = heir_conditions.is_active() and vim.fn.mode() or "n"
            return self.mode_colors_map[m]
          end,

        }
      }

      require('heirline').setup {
        opts = {
          colors = heir_colors,
        },
        statusline = heir_statusline,
        tabline = heir_tabline,
      }
      vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
    end,
  },
}
