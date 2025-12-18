-- lua/plugins/colors.lua
-- Colorscheme plugin configurations

-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
return {
    {
        'folke/tokyonight.nvim',
        priority = 1000, -- Load before all other plugins
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require('tokyonight').setup {
                styles = {
                    comments = { italic = false }, -- Disable italics in comments
                },
            }
            -- To enable the colorscheme, uncomment the line below
            -- vim.cmd.colorscheme 'tokyonight-night'
        end,
    },

    {
        'loctvl842/monokai-pro.nvim',
        priority = 1000,
        config = function()
            require('monokai-pro').setup {
                transparent_background = false,
                terminal_colors = true,
                devicons = true, -- Highlight icons from `nvim-web-devicons`
                styles = {
                    comment = { italic = true },
                    keyword = { italic = true },
                    type = { italic = true },
                    storageclass = { italic = true },
                    structure = { italic = true },
                    parameter = { italic = true },
                    annotation = { italic = true },
                    tag_attribute = { italic = true },
                },
                filter = 'pro', -- classic | octagon | pro | machine | ristretto | spectrum
                day_night = {
                    enable = false,
                    day_filter = 'pro',
                    night_filter = 'spectrum',
                },
                inc_search = 'background', -- underline | background
                background_clear = {
                    -- "float_win",
                    'toggleterm',
                    'telescope',
                    -- "which-key",
                    'renamer',
                    'notify',
                    -- "nvim-tree",
                    -- "neo-tree",
                    -- "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
                },
                plugins = {
                    bufferline = {
                        underline_selected = false,
                        underline_visible = false,
                    },
                    indent_blankline = {
                        context_highlight = 'default', -- default | pro
                        context_start_underline = false,
                    },
                },
            }
            -- Load the colorscheme (you can change to any available style)
            -- Different styles : pro, octagon, machine, ristretto, spectrum, classic
            vim.cmd.colorscheme 'monokai-pro'
        end,
    },
}
