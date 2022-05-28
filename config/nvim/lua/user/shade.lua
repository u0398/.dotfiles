-- File: /home/sergio/.config/nvim/lua/user/shade.lua
-- Last Change: Wed, 20 Apr 2022 10:41
-- dim inactive windows
-- site: https://github.com/sunjon/Shade.nvim

-- Use a protected call so we don't error out on first use
local status_ok, shade = pcall(require, "shade")
if not status_ok then
    return
end

require'shade'.setup({
  overlay_opacity = 65,
  opacity_step = 1,
  keys = {
    brightness_up    = '<C-Up>',
    brightness_down  = '<C-Down>',
    toggle           = '<Leader>s',
  }
})
