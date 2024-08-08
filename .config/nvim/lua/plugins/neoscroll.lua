-- karb94/neoscroll.nvim {{{2
-- A smooth scrolling neovim plugin
return {

  'karb94/neoscroll.nvim',
  keys = {
    { '<C-u>' }, { '<C-d>' },
    { '<C-b>' }, { '<C-f>' },
    { '<C-y>' }, { '<C-e>' },
    { 'zt' }, { 'zz' }, { 'zb' },
    { 'gk',
      function()
        require'neoscroll'.ctrl_u({ duration = 250 })
      end,
      mode = { 'n', 'v', 'x' },
      desc = 'scroll up'
    },
    { 'gj',
      function()
        require'neoscroll'.ctrl_d({ duration = 250 })
      end,
      mode = { 'n', 'v', 'x' },
      desc = 'scroll down'
    },
    { 'gK',
      function()
        require'neoscroll'.ctrl_b({ duration = 450 })
      end,
      mode = { 'n', 'v', 'x' },
      desc = 'scroll back'
    },
    { 'gJ',
      function()
        require'neoscroll'.ctrl_f({ duration = 450 })
      end,
      mode = { 'n', 'v', 'x' },
      desc = 'scroll forward'
    },

  },
  config = function()
    require'neoscroll'.setup {
      -- All these keys will be mapped to their corresponding default scrolling animation
      --mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = true, -- Hide cursor while scrolling
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
      respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      easing_function = nil, -- Default easing function
      pre_hook = nil, -- Function to run before the scrolling animation starts
      post_hook = nil, -- Function to run after the scrolling animation ends
    }
  end,
}
