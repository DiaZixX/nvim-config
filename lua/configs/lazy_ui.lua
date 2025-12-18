-- lua/config/lazy_ui.lua
-- Table of icons used for lazy.nvim UI

local icons = vim.g.have_nerd_font and {}
    or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤',
    }

return icons
