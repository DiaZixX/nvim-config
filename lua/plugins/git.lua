-- lua/plugins/git.lua
-- Git-related plugins

return {
    {
        'lewis6991/gitsigns.nvim', -- Adds git signs to the gutter and utilities for managing changes
        opts = {
            signs = {
                add = { text = '+' }, -- sign for added lines
                change = { text = '~' }, -- sign for modified lines
                delete = { text = '_' }, -- sign for deleted lines
                topdelete = { text = '‾' }, -- sign for top-line deletions
                changedelete = { text = '~' }, -- sign for modified+deleted lines
            },
        },
    },
}
