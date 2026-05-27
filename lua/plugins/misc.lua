-- lua/plugins/misc.lua
-- Miscellaneous utility plugins

return {
    {
        'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
        enabled = false, -- Disable by default
    },

    {
        'folke/todo-comments.nvim', -- Highlight TODO, NOTE, etc. in comments
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            signs = false, -- Disable gutter signs
        },
    },

    {
        'echasnovski/mini.nvim', -- Collection of small independent modules
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Surround actions
            --
            -- Operators (toujours suivis d'un motion ou text object) :
            --   sa<motion><char> : Add surrounding
            --   sd<char>         : Delete surrounding
            --   sr<old><new>     : Replace surrounding
            --   sf / sF          : Find surrounding (droite / gauche)
            --   sh               : Highlight surrounding
            --
            -- Suffixes next/last :
            --   sdn / sdl        : Delete next / last surrounding
            --   srn / srl        : Replace next / last surrounding
            --
            -- Caractères utiles :
            --   )  → ()   sans espaces    (  → ( ) avec espaces
            --   }  → {}   sans espaces    {  → { } avec espaces
            --   ]  → []   sans espaces    [  → [ ] avec espaces
            --   "  → ""   q  → ""
            --   '  → ''   `  → ``
            --   t  → tag HTML
            --   f  → function call
            --
            -- Exemples fréquents :
            --   saiw)  → entoure le mot de ()
            --   saiw"  → entoure le mot de ""
            --   sd"    → supprime les ""
            --   sr"'   → remplace " par '
            --   sr({   → remplace () par {}
            require('mini.surround').setup {
                search_method = 'cover_or_nearest',
                n_lines = 50,
                mappings = {
                    add = 'sa',
                    delete = 'sd',
                    find = 'sf',
                    find_left = 'sF',
                    highlight = 'sh',
                    replace = 'sr',
                    suffix_last = 'l',
                    suffix_next = 'n',
                },
            }

            -- Simple and easy statusline
            local statusline = require 'mini.statusline'
            statusline.setup { use_icons = vim.g.have_nerd_font }

            -- Customize cursor location section
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return '%2l:%-2v'
            end
        end,
    },
}
