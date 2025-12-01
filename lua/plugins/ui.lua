-- lua/plugins/ui.lua
-- UI-related plugins (statusline, bufferline, icons, etc.)

return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup {
        options = {
          mode = 'buffers',
          separator_style = 'slope', -- slope | slant
          themable = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          indicator = {
            style = 'underline', -- underline indicator
          },

          -- Diagnostics
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(_, _, diagnostics_dict, _)
            local s = ' '
            for e, n in pairs(diagnostics_dict) do
              local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or ' ')
              s = s .. n .. sym
            end
            return s
          end,

          -- Sidebar offsets (for Neo-tree)
          offsets = {
            {
              filetype = 'neo-tree',
              text = 'File Explorer',
              highlight = 'Directory',
              separator = true,
            },
          },

          -- Hover
          hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' },
          },

          -- Naming & sorting
          truncate_names = true,
          max_name_length = 25,
          max_prefix_length = 15,
          tab_size = 22,
          sort_by = 'insert_after_current',
          diagnostics_update_in_insert = false,
          color_icons = true,
          always_show_bufferline = true,

          -- Enable reordering and pinning
          move_wraps_at_end = true,
          persist_buffer_sort = true,
        },
      }

      -- Keymaps (Kickstart style)
      local map = vim.keymap.set
      map('n', '<leader>bp', '<Cmd>BufferLinePick<CR>', { desc = '[B]uffer [P]ick' })
      map('n', '<leader>bc', '<Cmd>BufferLinePickClose<CR>', { desc = '[B]uffer [C]lose (pick)' })
      map('n', '<leader>bn', '<Cmd>BufferLineCycleNext<CR>', { desc = '[B]uffer [N]ext' })
      map('n', '<leader>bb', '<Cmd>BufferLineCyclePrev<CR>', { desc = '[B]uffer [B]ack' })
      map('n', '<leader>b>', '<Cmd>BufferLineMoveNext<CR>', { desc = '[B]uffer Move [>] Right' })
      map('n', '<leader>b<', '<Cmd>BufferLineMovePrev<CR>', { desc = '[B]uffer Move [<] Left' })
      map('n', '<leader>bf', '<Cmd>BufferLineTogglePin<CR>', { desc = '[B]uffer Toggle [F]ix (Pin)' })
    end,
  },

  {
    'numToStr/Comment.nvim', -- Comment plugin with auto-detect symbol
    opts = {},
  },
}
