local core_modules = {
    "core.plugins",
    "core.settings",
    "core.mappings",
    "core.utils"
}

-- Using pcall we can handle better any loading issues
for _, module in ipairs(core_modules) do
    local ok, err = pcall(require, module)
    if not ok then
        error("Error loading " .. module .. "\n\n" .. err)
    end
end

--function map(mode, shortcut, command)
--  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
--end

--map('', '<capslock>', 'ns')

