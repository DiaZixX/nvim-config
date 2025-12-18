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
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. Add more languages if needed.
                local disable_filetypes = { c = false, cpp = false, python = false }
                local lsp_format_opt
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    lsp_format_opt = 'never'
                else
                    lsp_format_opt = 'fallback'
                end
                return {
                    timeout_ms = 3000,
                    lsp_format = lsp_format_opt,
                }
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                cpp = { 'clang-format' },
                python = { 'isort', 'black' },
                -- You can add JS/TS formatters here if needed
                -- javascript = { "prettierd", "prettier", stop_after_first = true },
            },
        },
    },
}
