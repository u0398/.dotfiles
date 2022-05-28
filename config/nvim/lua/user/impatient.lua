-- File: /home/sergio/.config/nvim/lua/user/impatient.lua
-- Last Change: Mon, 28 Feb 2022 19:58

local status_ok, impatient = pcall(require, "impatient")
if not status_ok then
  return
end

impatient.enable_profile()
