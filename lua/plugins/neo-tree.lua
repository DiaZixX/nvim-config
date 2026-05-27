-- lua/plugins/neo-tree.lua
-- Neo-tree file explorer plugin

return {
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- recommended for icons
            'MunifTanjim/nui.nvim',
        },
        cmd = 'Neotree', -- lazy-load on command
        keys = {
            { '\\', ':Neotree toggle<CR>', desc = 'NeoTree Toggle', silent = true },
        },
        config = function()
            require('neo-tree').setup {
                event_handlers = {
                    {
                        event = 'neo_tree_window_after_open',
                        handler = function()
                            vim.cmd 'wincmd ='
                        end,
                    },
                    {
                        event = 'neo_tree_window_after_close',
                        handler = function()
                            vim.cmd 'wincmd ='
                        end,
                    },
                },
                filesystem = {
                    follow_current_file = {
                        enabled = true, -- always focus the current file
                        leave_dirs_open = true, -- keep directories open when switching files
                    },
                    hijack_netrw_behavior = 'open_default', -- replace netrw on open
                },
                buffers = {
                    follow_current_file = {
                        enabled = true, -- focus the current buffer
                    },
                    group_empty_dirs = true, -- group empty directories in buffer list
                },
                window = {
                    mappings = {
                        ['<cr>'] = 'open', -- Enter -> open file in buffer
                        ['<tab>'] = 'open_tabnew', -- Tab -> open file in new tab
                        ['hs'] = 'open_split', -- s -> horizontal split
                        ['vs'] = 'open_vsplit', -- v -> vertical split
                        ['s'] = 'none',
                        ['v'] = 'none',
                    },
                },
            }
        end,
    },
}
