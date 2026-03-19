-- lua/plugins/substitute.lua
-- Keymaps pour substitution de mots sur ligne(s)

local function substitute_word()
    local target = vim.fn.expand '<cword>'
    if target == '' then
        return
    end

    local replacement = vim.fn.input('Remplacer "' .. target .. '" par: ')
    if replacement == '' then
        return
    end

    local escaped_target = vim.fn.escape(target, '/\\')
    local escaped_replacement = vim.fn.escape(replacement, '/\\')

    local line = vim.fn.line '.'
    vim.cmd(line .. 's/\\<' .. escaped_target .. '\\>/' .. escaped_replacement .. '/g')
end

local function substitute_word_all()
    local target = vim.fn.input 'Mot cible: '
    if target == '' then
        return
    end

    local replacement = vim.fn.input('Remplacer "' .. target .. '" par: ')
    if replacement == '' then
        return
    end

    local escaped_target = vim.fn.escape(target, '/\\')
    local escaped_replacement = vim.fn.escape(replacement, '/\\')

    local line = vim.fn.line '.'
    vim.cmd(line .. 's/' .. escaped_target .. '/' .. escaped_replacement .. '/g')
end

vim.keymap.set('n', '<leader>rw', substitute_word, {
    desc = '[R]eplace [W]ord under cursor (current line)',
    noremap = true,
    silent = true,
})

vim.keymap.set('n', '<leader>ra', substitute_word_all, {
    desc = '[R]eplace [A]ll occurrences (current line)',
    noremap = true,
    silent = true,
})

vim.keymap.set('v', '<leader>rw', function()
    local target = vim.fn.expand '<cword>'
    if target == '' then
        return
    end
    local replacement = vim.fn.input('Remplacer "' .. target .. '" par: ')
    if replacement == '' then
        return
    end
    local et = vim.fn.escape(target, '/\\')
    local er = vim.fn.escape(replacement, '/\\')
    vim.cmd("'<,'>s/\\<" .. et .. '\\>/' .. er .. '/g')
end, { desc = '[R]eplace [W]ord under cursor (selection)', noremap = true, silent = true })

vim.keymap.set('v', '<leader>ra', function()
    local target = vim.fn.input 'Mot cible: '
    if target == '' then
        return
    end
    local replacement = vim.fn.input('Remplacer "' .. target .. '" par: ')
    if replacement == '' then
        return
    end
    local et = vim.fn.escape(target, '/\\')
    local er = vim.fn.escape(replacement, '/\\')
    vim.cmd("'<,'>s/" .. et .. '/' .. er .. '/g')
end, { desc = '[R]eplace [A]ll (selection)', noremap = true, silent = true })

return {}
