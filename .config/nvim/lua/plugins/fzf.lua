-- ibhagwan/fzf-lua
-- Does anything need to be said?
return {
  'ibhagwan/fzf-lua',
  config = function()
    require'fzf-lua'.setup {
      hls = {
        border = "FloatBorder",
        preview_border = "FloatBorder",
        header_text = "Comment",
        header_bind = "Comment",
      },
      actions = {
        files = {
          ["default"] = require'fzf-lua'.actions.file_edit,
          ["ctrl-v"] = require'fzf-lua'.actions.file_split,
          ["ctrl-s"] = require'fzf-lua'.actions.file_vsplit,
          ["alt-q"] = require'fzf-lua'.actions.file_sel_to_qf,
        },
      },
      fzf_colors = {
        --["bg"] = { "bg", "Normal" },
        --["bg+"] = { "bg", "Normal" },
        ["fg"] = { "fg", "Comment" },
        ["fg+"] = { "fg", "Normal" },
        ["hl"] = { "fg", "Special" },
        ["hl+"] = { "fg", "Special" },
        ["info"] = { "fg", "PreProc" },
        ["prompt"] = { "fg", "Comment" },
        ["pointer"] = { "fg", "Special" },
        ["marker"] = { "fg", "Keyword" },
        ["spinner"] = { "fg", "Label" },
        ["header"] = { "fg", "Comment" },
        ["separator"] = { "fg", "FloatBorder" },
        ["scrollbar"] = { "fg", "FloatBorder" },
      },
      winopts = {
        height = 0.7,
        width = 0.8,
        row = 0.5,
        col = 0.5,
        preview = {
          layout = "vertical",
          vertical = "up:44%",
          scrollbar = false,
        },
      },
    }

    -- local fzf_map = function(keys, type, desc)
    --   local command = function()
    --     if type == "" then
    --       require("fzf-lua").builtin({
    --         winopts = {
    --           height = 0.2,
    --           width = 40,
    --           row = 0.4,
    --           col = 0.48,
    --         },
    --       })
    --     else
    --       require("fzf-lua")[type]({
    --         file_icons = false,
    --         git_icons = false,
    --         color_icons = false,
    --       })
    --     end
    --   end
    --   vim.keymap.set("n", keys, command, { desc = desc })
    -- end

    -- fzf_map("<leader>fz", "", "FZF")
    -- fzf_map("<leader>ff", "files", "FZF Files")
    -- fzf_map("<leader>fh", "help_tags", "FZF Help")
    -- fzf_map("<leader>fb", "buffers", "FZF Buffers")
    -- fzf_map("<leader>fg", "live_grep", "FZF Grep Word")
    -- fzf_map("<leader>fv", "grep_visual", "FZF Grep Visual")
    -- fzf_map("<leader>fr", "oldfiles", "FZF Recent files")
    -- fzf_map("<leader>fc", "grep_cword", "FZF Current Word")
    -- fzf_map("<leader>fd", "diagnostics_document", "FZF Diagnostics")

    --lsp
    -- fzf_map("<leader>lr", "lsp_references", "FZF LSP References")
    -- fzf_map("<leader>ld", "lsp_definitions", "FZF LSP Definitions")
    -- fzf_map("<leader>lI", "lsp_implementations", "FZF LSP Implementations")
    -- fzf_map("<leader>lt", "lsp_typedefs", "FZF LSP Type Definitions")
  end,
}
