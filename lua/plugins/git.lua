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
            current_line_blame = true, -- enable inline blame by default
            current_line_blame_opts = {
                delay = 500, -- delay in ms before showing blame
                virt_text_pos = 'eol', -- position : 'eol' | 'overlay' | 'right_align'
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>tb', require('gitsigns').toggle_current_line_blame, {
                    buffer = bufnr,
                    desc = '[T]oggle git [B]lame line',
                })
            end,
        },
    },
}
