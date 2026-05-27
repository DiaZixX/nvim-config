-- lua/plugins/treesitter.lua
-- Treesitter configuration

-- Highlight, edit, and navigate code
return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        init = function()
            -- Installation des parsers manquants
            local ensure_installed = {
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
            }
            local already_installed = require('nvim-treesitter.config').get_installed()
            local to_install = vim.iter(ensure_installed)
                :filter(function(p)
                    return not vim.tbl_contains(already_installed, p)
                end)
                :totable()
            if #to_install > 0 then
                require('nvim-treesitter').install(to_install)
            end

            -- Highlighting + indentation via autocommand (nouvelle API)
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    pcall(vim.treesitter.start)
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
        opts = {
            auto_install = true,
        },
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
            node_types = {
                rust = { 'impl_item', 'function_item', 'struct_item', 'enum_item', 'trait_item' },
                c = { 'function_definition', 'struct_specifier', 'enum_specifier', 'union_specifier' },
                python = { 'function_definition', 'class_definition' },
                lua = { 'function_declaration', 'function_definition' },
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
