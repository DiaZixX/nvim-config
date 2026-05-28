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
            -- ===== mini.ai =====
            -- Extend and create a/i textobjects
            --
            -- Builtins conservés :
            --   a( i(  a) i)  → parenthèses
            --   a[ i[  a] i]  → crochets
            --   a{ i{  a} i}  → accolades
            --   a< i<  a> i>  → chevrons
            --   a" i"  a' i'  a` i`  → quotes
            --
            -- Custom ajoutés :
            --   af / if  → fonction complète  (treesitter)
            --   ac / ic  → classe             (treesitter)
            --   ao / io  → if / for / while   (treesitter)
            --   at / it  → tag HTML/XML
            --   ad / id  → nombre entier
            --   au / iu  → function call (curseur sur le nom)
            --   ag / ig  → buffer entier
            local ai = require 'mini.ai'

            require('mini.ai').setup {
                n_lines = 500,

                custom_textobjects = {
                    -- Fonction (treesitter) — remplace le builtin basique
                    f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },

                    -- Classe (treesitter)
                    c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },

                    -- Bloc / condition / loop (treesitter)
                    -- vio → sélectionne le corps d'un if/for/while
                    o = ai.gen_spec.treesitter {
                        a = { '@block.outer', '@conditional.outer', '@loop.outer' },
                        i = { '@block.inner', '@conditional.inner', '@loop.inner' },
                    },

                    -- Tag HTML/XML  →  dit / vat
                    t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },

                    -- Nombre entier  →  vid / dad
                    d = { '%f[%d]%d+' },

                    -- Function call (curseur sur le nom)  →  viu = args seulement
                    u = ai.gen_spec.function_call(),

                    -- Buffer entier  →  vig / yag
                    g = function()
                        local from = { line = 1, col = 1 }
                        local to = {
                            line = vim.fn.line '$',
                            col = math.max(vim.fn.getline('$'):len(), 1),
                        }
                        return { from = from, to = to }
                    end,
                },
            }

            -- ===== mini.surround =====
            -- Surround actions (dot-repeatable)
            --
            -- Opérateurs (suivis d'un motion ou text object) :
            --   sa<motion><char>  : Add surrounding
            --   sd<char>          : Delete surrounding
            --   sr<old><new>      : Replace surrounding
            --   sf / sF           : Find surrounding (droite / gauche)
            --   sh                : Highlight surrounding
            --
            -- Suffixes next/last :
            --   sdn / sdl         : Delete next / last surrounding
            --   srn / srl         : Replace next / last surrounding
            --
            -- Caractères utiles :
            --   )  → ()  sans espaces     (  → ( )  avec espaces
            --   }  → {}  sans espaces     {  → { }  avec espaces
            --   ]  → []  sans espaces     [  → [ ]  avec espaces
            --   "  → ""    '  → ''    `  → ``
            --   q  → ""  (alias double quote)
            --   t  → tag HTML     f  → function call
            --
            -- Exemples fréquents :
            --   saiw)   → entoure le mot de ()
            --   saiw"   → entoure le mot de ""
            --   sd"     → supprime les ""
            --   sr"'    → remplace " par '
            --   sr({    → remplace () par {}
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

            -- ===== mini.statusline =====
            local statusline = require 'mini.statusline'
            statusline.setup { use_icons = true }

            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return '%2l:%-2v'
            end
        end,
    },
}
