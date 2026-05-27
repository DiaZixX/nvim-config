-- lua/plugins/which-key.lua
-- Plugin to show pending keybinds and help discover shortcuts

return {
    {
        'folke/which-key.nvim',
        event = 'VimEnter', -- load after Vim enters
        opts = {
            delay = 0,
            icons = {
                mappings = vim.g.have_nerd_font,
                keys = vim.g.have_nerd_font and {} or {
                    Up = '<Up> ',
                    Down = '<Down> ',
                    Left = '<Left> ',
                    Right = '<Right> ',
                    C = '<C-…> ',
                    M = '<M-…> ',
                    D = '<D-…> ',
                    S = '<S-…> ',
                    CR = '<CR> ',
                    Esc = '<Esc> ',
                    ScrollWheelDown = '<ScrollWheelDown> ',
                    ScrollWheelUp = '<ScrollWheelUp> ',
                    NL = '<NL> ',
                    BS = '<BS> ',
                    Space = '<Space> ',
                    Tab = '<Tab> ',
                    F1 = '<F1>',
                    F2 = '<F2>',
                    F3 = '<F3>',
                    F4 = '<F4>',
                    F5 = '<F5>',
                    F6 = '<F6>',
                    F7 = '<F7>',
                    F8 = '<F8>',
                    F9 = '<F9>',
                    F10 = '<F10>',
                    F11 = '<F11>',
                    F12 = '<F12>',
                },
            },

            spec = {
                -- Leader groups
                { '<leader>c', group = '[C]ode', mode = { 'n' } },
                { '<leader>d', group = '[D]ocument' },
                { '<leader>s', group = '[S]earch' },
                { '<leader>w', group = '[W]orkspace' },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
                { '<leader>r', group = '[R]ename & [R]eplace' },
                { '<leader>b', group = '[B]uffer' },
                { '<leader>n', group = '[N]eogen' },
                -- Surround groups (mini.surround, préfixe 's')
                { 'sa', group = '[S]urround [A]dd', mode = { 'n', 'v' } },
                { 'sd', group = '[S]urround [D]elete', mode = { 'n' } },
                { 'sr', group = '[S]urround [R]eplace', mode = { 'n' } },
                { 'sf', group = '[S]urround [F]ind →', mode = { 'n' } },
                { 'sF', group = '[S]urround [F]ind ←', mode = { 'n' } },
                { 'sh', group = '[S]urround [H]ighlight', mode = { 'n' } },
            },
        },
    },
}
