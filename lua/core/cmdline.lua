require('vim._core.ui2').enable {} -- nouvelle interface 0.12, expérimentale

vim.o.wildmode = 'noselect:lastused,full'
vim.o.wildoptions = 'pum,fuzzy'
vim.api.nvim_create_autocmd('CmdlineChanged', {
    pattern = ':',
    callback = function()
        vim.fn.wildtrigger()
    end, -- suggestions pendant la frappe
})
vim.o.cmdheight = 0 -- la ligne n'apparaît que lorsqu'elle sert
