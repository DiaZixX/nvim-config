-- lua/core/autocmds.lua
-- Autocommands configuration

local api = vim.api

-- ===== Highlight on Yank =====
-- Highlights text briefly when yanking (copying) it
-- Try it with commands like `yap` in normal mode
local yank_group = api.nvim_create_augroup('KickstartHighlightYank', { clear = true })

api.nvim_create_autocmd('TextYankPost', {
  group = yank_group,
  desc = 'Highlight when yanking text',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200 }
  end,
})

-- ===== Open on Neo-tree =====
-- Avoid having buffer on folder
api.nvim_create_autocmd('VimEnter', {
  callback = function(data)
    -- Check if Neovim was opened on a directory
    if vim.fn.isdirectory(data.file) == 1 then
      -- Open a new empty buffer to replace the default directory buffer
      vim.cmd.enew()
      -- Delete the automatically created directory buffer
      vim.cmd.bdelete(data.buf)
      -- Change the working directory to the opened folder
      vim.cmd.cd(data.file)
      -- Open Neo-tree on the left side and reveal the folder
      require('neo-tree.command').execute {
        source = 'filesystem',
        position = 'left',
        reveal = true,
      }
    end
  end,
})
