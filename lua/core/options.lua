-- lua/core/options.lua
-- General Neovim options configuration

local opt = vim.opt

-- ===== UI =====
opt.number = true -- Show absolute line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true -- Highlight the current line
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.signcolumn = 'yes' -- Always show the sign column
opt.wrap = false -- Disable line wrap
opt.scrolloff = 10 -- Minimum number of screen lines visible above/below the cursor
vim.opt.showmode = false -- Don't show mode, already on status line
opt.list = true -- Show invisibler characters
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Defines how invisible characters are showed

-- ===== Indentation =====
opt.tabstop = 4 -- Number of spaces a tab counts for
opt.shiftwidth = 4 -- Number of spaces to use for autoindent
opt.expandtab = true -- Convert tabs to spaces
opt.smartindent = true -- Smart autoindenting on new lines
opt.smarttab = true -- Smart indent when using tabs
opt.breakindent = true -- Break indent for too long lines

-- ===== Search =====
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- Override ignorecase if search contains capitals
opt.incsearch = true -- Show search results as you type
opt.hlsearch = true -- Highlight all matches

-- ===== Files & History =====
opt.undofile = false -- Disable persistent undo
opt.swapfile = true -- Enable swap files
opt.backup = false -- Disable backup files
opt.writebackup = false -- No temp backup during writing
opt.confirm = true -- If perfoming an operation that would fail due to unsaved changes in the buffer instead raise dialog

-- ===== Splits =====
opt.splitright = true -- Vertical split goes to the right
opt.splitbelow = true -- Horizontal split goes below

-- ===== Input =====
opt.mouse = 'a' -- Enable mouse support
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  opt.clipboard = 'unnamedplus' -- Sync OS clipboard and Neovim
end)

-- ===== Performance =====
opt.updatetime = 250 -- Faster CursorHold & swap events
opt.timeoutlen = 300 -- Faster mapped sequence response

-- ===== Live substitution preview =====
opt.inccommand = 'split'
