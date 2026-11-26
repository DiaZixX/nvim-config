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
        vim.hl.on_yank { higroup = 'IncSearch', timeout = 200 }
    end,
})

-- ===== Open on Neo-tree =====
-- Avoid having buffer on folder
api.nvim_create_autocmd('VimEnter', {
    callback = function(data)
        if vim.fn.isdirectory(data.file) ~= 1 then
            return
        end

        vim.cmd.enew()
        -- Le buffer vide disparaît dès qu'on ouvre un fichier à sa place
        vim.bo.bufhidden = 'wipe'
        vim.cmd.bdelete(data.buf)
        vim.cmd.cd(data.file)

        -- Ensure Neo-tree is loaded before using it
        require('lazy').load { plugins = { 'neo-tree.nvim' } }

        require('neo-tree.command').execute {
            source = 'filesystem',
            position = 'left',
            reveal = true,
        }
    end,
})

-- ===== Force filetype for .h files =====
vim.g.c_syntax_for_h = true

-- Silence treesitter "Index out of bounds" during formatting
api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.c', '*.h', '*.cpp' },
    callback = function()
        vim.treesitter.stop()
    end,
})

api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.c', '*.h', '*.cpp' },
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
