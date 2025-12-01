-- lua/plugins/init.lua
-- Central file that gathers all plugin specs for lazy.nvim

local plugins = {}

-- ===============================
-- Core / Utility plugins
-- ===============================
plugins[1] = { 'nvim-lua/plenary.nvim' } -- required by many plugins

-- ===============================
-- LSP & Autocompletion
-- ===============================
vim.list_extend(plugins, require 'plugins.lsp')
vim.list_extend(plugins, require 'plugins.cmp')

-- ===============================
-- DAP debugger
-- ===============================
vim.list_extend(plugins, require 'plugins.debug')

-- ===============================
-- Treesitter
-- ===============================
vim.list_extend(plugins, require 'plugins.treesitter')

-- ===============================
-- Telescope (fuzzy finder)
-- ===============================
vim.list_extend(plugins, require 'plugins.telescope')

-- ===============================
-- File explorer
-- ===============================
vim.list_extend(plugins, require 'plugins.neo-tree')

-- ===============================
-- UI / Bufferline
-- ===============================
vim.list_extend(plugins, require 'plugins.ui')
vim.list_extend(plugins, require 'plugins.colors')

-- ===============================
-- Git / Version control
-- ===============================
vim.list_extend(plugins, require 'plugins.git')

-- ===============================
-- Keybinding helper
-- ===============================
vim.list_extend(plugins, require 'plugins.which-key')

-- ===============================
-- Utility / Misc plugins
-- ===============================
vim.list_extend(plugins, require 'plugins.misc')
vim.list_extend(plugins, require 'plugins.conform')
vim.list_extend(plugins, require 'plugins.autopairs')

return plugins
