-- lua/plugins/conform.lua
-- Autoformat plugin configuration

return {
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format { async = true, lsp_format = 'fallback' }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = true,
            format_on_save = {
                timeout_ms = 3000,
                lsp_format = 'fallback',
            },
            formatters = {
                ['clang-format'] = {
                    prepend_args = {
                        '--style=file',
                    },
                },
            },
            formatters_by_ft = {
                lua = { 'stylua' },
                c = { 'clang-format' },
                cpp = { 'clang-format' },
                python = { 'isort', 'black' },
                tex = { 'latexindent' },
                -- You can add JS/TS formatters here if needed
                -- javascript = { "prettierd", "prettier", stop_after_first = true },
            },
        },
    },
}
