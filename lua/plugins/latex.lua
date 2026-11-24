-- lua/plugins/latex.lua
return {
    {
        'lervag/vimtex',
        lazy = false, -- vimtex doit se charger au démarrage
        init = function()
            vim.g.vimtex_view_method = 'zathura' -- ou 'sioyek', 'skim' (macOS)
            vim.g.vimtex_compiler_method = 'latexmk'
            vim.g.vimtex_quickfix_mode = 0 -- moins intrusif sur les warnings
            vim.g.vimtex_syntax_enabled = 1
            vim.g.vimtex_mappings_enabled = 1
            vim.g.vimtex_imaps_enabled = 1
            vim.g.vimtex_matchparen_enabled = 1
        end,
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'tex',
            callback = function()
                vim.keymap.set('i', ']]', '<Plug>(vimtex-delim-close)', {
                    buffer = true,
                    remap = true,
                    desc = 'Close LaTeX environment',
                })
            end,
        }),
    },
}
