-- lua/core/keymaps.lua
-- Keymaps configuration

local keymap = vim.keymap

-- ===== General =====
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- ===== Diagnostics =====
vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next [D]iagnostic message' })
keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror message' })
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- ===== Terminal =====
-- Exit terminal mode in the builtin terminal with a shortcut
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ===== Window navigation =====
-- Move focus between splits
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- ===== Neotree =====
keymap.set('n', '\\', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Neo-tree panel' })

-- ===== Buffers =====
keymap.set('n', '<leader>x', ':bdelete<CR>', { noremap = true, silent = true, desc = '[B]uffer [D]elete current' })

-- ===== Optional =====
-- Disable arrow keys in normal mode to encourage hjkl usage
keymap.set('n', '<left>', '<cmd>echo "Use h to move!"<CR>')
keymap.set('n', '<right>', '<cmd>echo "Use l to move!"<CR>')
keymap.set('n', '<up>', '<cmd>echo "Use k to move!"<CR>')
keymap.set('n', '<down>', '<cmd>echo "Use j to move!"<CR>')
