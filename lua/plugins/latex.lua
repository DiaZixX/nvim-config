-- lua/plugins/latex.lua
return {
    {
        'lervag/vimtex',
        lazy = false,
        init = function()
            vim.g.vimtex_view_method = 'zathura'
            vim.g.vimtex_compiler_method = 'latexmk'
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_syntax_enabled = 1
            vim.g.vimtex_mappings_enabled = 1
            vim.g.vimtex_imaps_enabled = 1
            vim.g.vimtex_matchparen_enabled = 1

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'tex',
                callback = function()
                    vim.keymap.set('i', ']]', '<Plug>(vimtex-delim-close)', {
                        buffer = true,
                        remap = true,
                        desc = 'Close LaTeX environment',
                    })
                end,
            })
        end,
    },
}
