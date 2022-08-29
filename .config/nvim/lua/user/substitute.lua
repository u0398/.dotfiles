-- File: /home/sergio/.config/nvim/lua/user/substitute.lua
-- Last Change: Fri, 04 Mar 2022 20:16

local status_ok, substitute = pcall(require, "substitute")
if not status_ok then
    return
end

require("substitute").setup()

vim.api.nvim_set_keymap("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
vim.api.nvim_set_keymap("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "sxc", "<cmd>lua require('substitute.exchange').cancel()<cr>", { noremap = true })
