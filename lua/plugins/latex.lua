-- lua/plugins/latex.lua
return {
    {
        'lervag/vimtex',
        lazy = false, -- vimtex doit se charger au démarrage
        init = function()
            vim.g.vimtex_view_method = 'zathura' -- ou 'sioyek', 'skim' (macOS)
            vim.g.vimtex_compiler_method = 'latexmk'
            vim.g.vimtex_quickfix_mode = 0 -- moins intrusif sur les warnings
            vim.g.vimtex_syntax_enabled = 0 -- on laisse Treesitter gérer la coloration
            vim.g.vimtex_mappings_enabled = 1
        end,
    },
}
