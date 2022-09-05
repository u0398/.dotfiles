-- File: /home/sergio/.config/nvim/lua/user/lualine.lua
-- Last Change: Sat, 30 Apr 2022 18:27

local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {
	"location",
	padding = 0,
}

-- cool function for progress
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local custom_powerline = require'lualine.themes.powerline'


custom_powerline.normal.a.bg = '#ffffff'
custom_powerline.normal.a.fg = '#000000'
custom_powerline.normal.b.bg = '#444444'
custom_powerline.normal.b.fg = '#ffffff'
custom_powerline.normal.c.bg = '#1c1c1c'
custom_powerline.normal.c.fg = '#ffffff'

custom_powerline.insert.a.bg = '#25be6a'
custom_powerline.insert.a.fg = '#000000'
custom_powerline.insert.b.bg = '#0c3e22'
custom_powerline.insert.b.fg = '#2ce47f'
custom_powerline.insert.c.bg = '#0b2013'
custom_powerline.insert.c.fg = '#2ce47f'

custom_powerline.visual.a.bg = '#e23434'
custom_powerline.visual.a.fg = '#000000'

custom_powerline.replace.a.bg = '#e2df34'
custom_powerline.replace.a.fg = '#000000'

custom_powerline.inactive.a.bg = '#666666'
custom_powerline.inactive.a.fg = '#000000'
custom_powerline.inactive.b.bg = '#444444'
custom_powerline.inactive.b.fg = '#ffffff'
custom_powerline.inactive.c.bg = '#1c1c1c'
custom_powerline.inactive.c.fg = '#444444'

lualine.setup({
	options = {
		icons_enabled = true,
		theme = custom_powerline,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { branch, diagnostics },
		-- lualine_c = {},
    lualine_c = {
      {"diagnostics", sources = {"nvim_lsp"}},
        function()
          return "%="
        end,
          "filename"
      },
		--lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_x = { diff, spaces, "encoding"},
    lualine_y = { filetype },
		lualine_z = { location },
--		lualine_z = { progress },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
    lualine_c = {
      {"diagnostics", sources = {"nvim_lsp"}},
        function()
          return "%="
        end,
          "filename"
      },
    --lualine_c = { filename },
		lualine_x = { "location" },
		lualine_y = {},
--		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
