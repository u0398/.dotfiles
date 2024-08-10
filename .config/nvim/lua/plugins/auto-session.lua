-- rmagatti/auto-session
-- seamless automatic session management
return {
  'rmagatti/auto-session',
  lazy = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
    { 'tiagovla/scope.nvim',
      lazy = false,
      config = true,
    },
  },
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>ss', '<cmd>SessionSearch<CR>', desc = 'search' },
    { '<leader>sS', '<cmd>SessionSave<CR>', desc = 'save' },
    { '<leader>sd', '<cmd>SessionDelete<CR>', desc = 'delete session' },
    { '<leader>sp', '<cmd>SessionPurgeOrphaned<CR>', desc = 'purge orphaned' },
    { '<leader>sa', '<cmd>SessionToggleAutoSave<CR>', desc = 'toggle autosave' },
  },
  config = function()
    require'auto-session'.setup {
      silent_restore = false,
      -- auto_session_enabled = true,
      -- auto_save_enabled = true,
      -- auto_session_save_enabled = true,
      auto_session_create_enabled = false,
      bypass_session_save_file_types = { 'dashboard', 'fugitive', 'help' },
      session_lens = {
        -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
      pre_save_cmds = { "lua vim.cmd([[ScopeSaveState]])" },
      post_restore_cmds = { "lua vim.cmd([[ScopeLoadState]])" }
    }
  end,
}
