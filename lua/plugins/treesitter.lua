-- lua/plugins/treesitter.lua
-- Treesitter configuration

-- Highlight, edit, and navigate code
return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        lazy = false,
        config = function()
            -- install() ignore les parsers déjà présents
            require('nvim-treesitter').install {
                'bash', 'c', 'cpp', 'diff', 'html', 'java', 'json', 'latex', 'lua', 'luadoc',
                'markdown', 'markdown_inline', 'python', 'query', 'rust', 'vim', 'vimdoc',
            }

            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
                callback = function(ev)
                    local lang = vim.treesitter.language.get_lang(ev.match)
                    -- latex : on laisse la coloration à VimTeX
                    if not lang or lang == 'latex' or not vim.treesitter.language.add(lang) then
                        return
                    end
                    vim.treesitter.start(ev.buf, lang)
                    if vim.treesitter.query.get(lang, 'indents') then
                        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        lazy = false,
        opts = {
            enable = true,
            multiwindow = true,
            max_lines = 3,
            min_window_height = 0,
            line_numbers = true,
            multiline_threshold = 1,
            trim_scope = 'outer',
            mode = 'cursor',
            separator = '-',
            zindex = 20,
        },
        keys = {
            {
                '[C', -- [c reste le « changement précédent » en mode diff
                function()
                    require('treesitter-context').go_to_context(vim.v.count1)
                end,
                desc = 'Jump to context (sticky header)',
            },
        },
    },
}
