-- File: /home/sergio/.config/nvim/lua/user/beacon.lua
-- Last Change: Sun, 27 Feb 2022 15:42

local status_ok, beacon = pcall(require, "beacon")
if not status_ok then
    return
end

vim.g.beacon_minimal_jump = 5

