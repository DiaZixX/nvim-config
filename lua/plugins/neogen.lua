-- lua/plugins/neogen.lua
-- Documentation generator using Neogen

return {
    {
        'danymat/neogen',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'L3MON4D3/LuaSnip',
        },
        config = function()
            local neogen = require 'neogen'

            neogen.setup {
                enabled = true,
                snippet_engine = 'luasnip',

                -- Active les langages que tu utilises
                languages = {
                    c = {
                        template = {
                            annotation_convention = 'doxygen',
                        },
                    },
                    cpp = {
                        template = {
                            annotation_convention = 'doxygen',
                        },
                    },
                    rust = {
                        template = {
                            annotation_convention = 'rustdoc',
                        },
                    },
                    python = {
                        template = {
                            annotation_convention = 'google_docstrings',
                        },
                    },
                    lua = {
                        template = {
                            annotation_convention = 'ldoc',
                        },
                    },
                },
            }

            -- Keymaps pratiques
            vim.keymap.set('n', '<leader>nf', function()
                neogen.generate { type = 'func' }
            end, { desc = '[N]eogen [F]unction documentation' })

            vim.keymap.set('n', '<leader>nc', function()
                neogen.generate { type = 'class' }
            end, { desc = '[N]eogen [C]lass documentation' })

            vim.keymap.set('n', '<leader>nt', function()
                neogen.generate { type = 'type' }
            end, { desc = '[N]eogen [T]ype documentation' })

            vim.keymap.set('n', '<leader>nF', function()
                neogen.generate { type = 'file' }
            end, { desc = '[N]eogen [F]ile documentation' })

            -- Génération automatique selon le contexte
            vim.keymap.set('n', '<leader>ng', function()
                neogen.generate()
            end, { desc = '[N]eogen [G]enerate documentation' })
        end,
    },
}
