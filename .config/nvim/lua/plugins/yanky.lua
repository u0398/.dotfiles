return {
  'gbprod/yanky.nvim',
  dependencies = {
    { 'kkharji/sqlite.lua' }
  },
  opts = {
    history_length = 100,
    sync_with_numbered_registers = true,
    storage = 'sqlite',
    cancel_event = 'update',
    ignore_registers = { '_' },
    update_register_on_cycle = false,
    system_clipboard = {
      sync_with_ring = true,
    },
  },
  keys = {
    { '<leader>p',
      function()
        local utils = require'yanky.utils'
        local map = require'yanky.telescope.mapping'
        local telescope = require'telescope'

        telescope.extensions.yank_history.yank_history({
          picker = {
            telescope = {
              mappings = {
                default = map.put('p'),
                i = {
                  ['<c-j>'] = map.put('p'),
                  ['<c-k>'] = map.put('P'),
                  ['<c-h>'] = map.put('gp'),
                  ['<c-l>'] = map.put('gP'),
                  ['<c-x>'] = map.delete(),
                  ['<c-r>'] = map.set_register(utils.get_default_register()),
                },
                n = {
                  p = map.put('p'),
                  P = map.put('P'),
                  d = map.delete(),
                  r = map.set_register(utils.get_default_register())
                },
              }
            }
          }
        })
      end,
      mode = { 'n', 'x' }, desc = 'Open Yank History'
    },
    { 'y',     '<Plug>(YankyYank)',       mode = { 'n', 'x' }, desc = 'Yank text' },
    { 'p',     '<Plug>(YankyPutAfter)',   mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
    { 'P',     '<Plug>(YankyPutBefore)',  mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
    { 'gp',    '<Plug>(YankyGPutAfter)',  mode = { 'n', 'x' }, desc = 'Put yanked text after selection' },
    { 'gP',    '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before selection' },
    { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Select previous entry through yank history' },
    { '<c-n>', '<Plug>(YankyNextEntry)',     desc = 'Select next entry through yank history' },
    { ']p',    '<Plug>(YankyPutIndentAfterLinewise)',    desc = 'Put indented after cursor (linewise)' },
    { '[p',    '<Plug>(YankyPutIndentBeforeLinewise)',   desc = 'Put indented before cursor (linewise)' },
    { ']P',    '<Plug>(YankyPutIndentAfterLinewise)',    desc = 'Put indented after cursor (linewise)' },
    { '[P',    '<Plug>(YankyPutIndentBeforeLinewise)',   desc = 'Put indented before cursor (linewise)' },
    { '>p',    '<Plug>(YankyPutIndentAfterShiftRight)',  desc = 'Put and indent right' },
    { '<p',    '<Plug>(YankyPutIndentAfterShiftLeft)',   desc = 'Put and indent left' },
    { '>P',    '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put before and indent right' },
    { '<P',    '<Plug>(YankyPutIndentBeforeShiftLeft)',  desc = 'Put before and indent left' },
    { '=p',    '<Plug>(YankyPutAfterFilter)',            desc = 'Put after applying a filter' },
    { '=P',    '<Plug>(YankyPutBeforeFilter)',           desc = 'Put before applying a filter' },
  },
}
