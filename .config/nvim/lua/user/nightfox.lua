local options = {
  transparent = true,
  dim_inactive = true,
  barbar = true,
  styles = {
    comments = "italic",
    keywords = "bold",
    types = "italic,bold"
  }
}

local palettes = {}

local specs = {}

local groups = {
  carbonfox = {
    BufferCurrent = { bg = "#777777", fg = "#ffffff" },
    BufferCurrentIndex = { bg = "#777777", fg = "#ffffff" },
    BufferCurrentMod = { bg = "#777777", fg = "#ffffff" },
    BufferCurrentSign = { bg = "#777777", fg = "#1c1c1c" },
    BufferCurrentTarget = { bg = "#777777", fg = "#ffffff" },
    BufferVisible = { bg = "#444444", fg = "#bbbbbb" },
    BufferVisibleIndex = { bg = "#444444", fg = "#bbbbbb" },
    BufferVisibleMod = { bg = "#444444", fg = "#bbbbbb" },
    BufferVisibleSign = { bg = "#444444", fg = "#1c1c1c" },
    BufferVisibleTarget = { bg = "#444444", fg = "#bbbbbb" },
    BufferInactive = { bg = "#444444", fg = "#bbbbbb" },
    BufferInactiveIndex = { bg = "#444444", fg = "#bbbbbb" },
    BufferInactiveMod = { bg = "#444444", fg = "#bbbbbb" },
    BufferInactiveSign = { bg = "#444444", fg = "#1c1c1c" },
    BufferInactiveTarget = { bg = "#444444", fg = "#bbbbbb" },
    BufferTabpage = { bg = "#1c1c1c", fg = "#ffffff" },
    BufferTabpageFill = { bg = "#1c1c1c", fg = "#1c1c1c" },
    Normal = { bg = "#111111" }
  }
}

require("nightfox").setup({ options = options, palettes = palettes, specs = specs, groups = groups })

vim.cmd("colorscheme carbonfox")


