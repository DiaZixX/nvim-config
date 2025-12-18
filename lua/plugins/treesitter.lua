-- lua/plugins/treesitter.lua
-- Treesitter configuration

-- Highlight, edit, and navigate code
return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs',
        opts = {
            ensure_installed = {
                'bash',
                'c',
                'diff',
                'html',
                'lua',
                'luadoc',
                'markdown',
                'markdown_inline',
                'query',
                'vim',
                'vimdoc',
                'latex',
                'java',
                'python',
                'rust',
            },
            auto_install = true,
            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                --  If you are experiencing weird indenting issues, add the language to
                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = { 'ruby' },
            },
            indent = { enable = true, disable = { 'ruby' } },
        },
        -- Additional Treesitter modules can be explored separately:
        -- Incremental selection, textobjects, context, etc.
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        lazy = false,
        opts = {
            enable = true,
            multiwindow = true, -- Enable multiwindow support.
            max_lines = 3, -- Nombre maximum de lignes de contexte à afficher
            min_window_height = 0,
            line_numbers = true,
            multiline_threshold = 1, -- Maximum number of lines to show for a single context
            trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded
            mode = 'cursor', -- Line used to calculate context. 'cursor' ou 'topline'
            separator = '-', -- Separator between context and content. Should be a single character string, like '-'.
            zindex = 20,
            node_types = {
                rust = { 'impl_item', 'function_item', 'struct_item', 'enum_item', 'trait_item' },
                c = { 'function_definition', 'struct_specifier', 'enum_specifier', 'union_specifier' },
                python = { 'function_definition', 'class_definition' },
                lua = { 'function_declaration', 'function_definition' },
                -- Add other language if needed
            },
        },
        keys = {
            {
                '[c',
                function()
                    require('treesitter-context').go_to_context(vim.v.count1)
                end,
                desc = 'Jump to context (sticky header)',
            },
        },
    },
}
