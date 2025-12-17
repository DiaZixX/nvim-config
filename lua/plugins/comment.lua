-- lua/plugins/comment.lua
-- Configuration avancée pour les commentaires avec keymaps personnalisés

return {
    {
        'numToStr/Comment.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring', -- Détection intelligente du type de commentaire (TSX, Vue, etc.)
        },
        config = function()
            -- Configuration de nvim-ts-context-commentstring pour les langages avec plusieurs syntaxes
            require('ts_context_commentstring').setup {
                enable_autocmd = false, -- Désactiver l'autocommand car Comment.nvim le gère
            }

            -- Configuration de Comment.nvim
            require('Comment').setup {
                -- Intégration avec nvim-ts-context-commentstring
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),

                -- Hook appelé après le toggle (rien par défaut)
                post_hook = function() end,

                -- Ajout d'espace après le symbole de commentaire
                padding = true,

                -- Garde le curseur à sa position lors du toggle
                sticky = true,

                -- Lignes à ignorer (pattern pour les lignes vides)
                ignore = '^$',

                -- Configuration des mappings
                toggler = {
                    line = '<leader>cc', -- Toggle comment pour la ligne courante
                    block = '<leader>cb', -- Toggle block comment
                },
                opleader = {
                    line = '<leader>c', -- Opérateur pour commenter (ex: <leader>c3j pour 3 lignes)
                    block = '<leader>b', -- Opérateur pour block comment
                },

                -- Mappings additionnels
                extra = {
                    above = '<leader>cO', -- Ajouter commentaire ligne au-dessus
                    below = '<leader>co', -- Ajouter commentaire ligne en-dessous
                    eol = '<leader>cA', -- Ajouter commentaire en fin de ligne
                },

                -- Active les mappings en mode visuel
                mappings = {
                    basic = true,
                    extra = true,
                },
            }

            -- Keymaps personnalisés additionnels

            -- Toggle commentaire en mode visuel avec <leader>c
            vim.keymap.set('v', '<leader>c', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', {
                desc = '[C]omment toggle linewise (visual)',
                noremap = true,
                silent = true,
            })

            -- Toggle block comment en mode visuel avec <leader>b
            vim.keymap.set('v', '<leader>b', '<ESC><cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<CR>', {
                desc = '[B]lock comment toggle (visual)',
                noremap = true,
                silent = true,
            })
        end,
    },

    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        lazy = true,
        opts = {
            enable_autocmd = false,
        },
    },
}
