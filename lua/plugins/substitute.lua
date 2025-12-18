-- lua/plugins/substitute.lua
-- Keymaps pour substitution de mots sur ligne(s)

-- Fonction pour substituer un mot par un autre
local function substitute_word()
    -- Récupérer le mot sous le curseur
    local word = vim.fn.expand '<cword>'

    -- Demander le mot de remplacement
    local replacement = vim.fn.input('Remplacer "' .. word .. '" par: ')

    -- Si l'utilisateur annule (ESC), ne rien faire
    if replacement == '' then
        return
    end

    -- Échapper les caractères spéciaux pour la regex
    local escaped_word = vim.fn.escape(word, '/\\')
    local escaped_replacement = vim.fn.escape(replacement, '/\\')

    -- Déterminer si on est en mode visuel
    local mode = vim.fn.mode()

    if mode == 'v' or mode == 'V' then
        -- Mode visuel : substituer dans la sélection
        vim.cmd("'<,'>s/\\<" .. escaped_word .. '\\>/' .. escaped_replacement .. '/g')
    else
        -- Mode normal : substituer sur la ligne courante
        vim.cmd('s/\\<' .. escaped_word .. '\\>/' .. escaped_replacement .. '/g')
    end

    -- Effacer le highlight de recherche
    vim.cmd 'nohlsearch'
end

-- Fonction pour substituer toutes les occurrences d'un mot
local function substitute_word_all()
    -- Récupérer le mot sous le curseur
    local word = vim.fn.expand '<cword>'

    -- Demander le mot de remplacement
    local replacement = vim.fn.input('Remplacer toutes les occurrences de "' .. word .. '" par: ')

    -- Si l'utilisateur annule (ESC), ne rien faire
    if replacement == '' then
        return
    end

    -- Échapper les caractères spéciaux pour la regex
    local escaped_word = vim.fn.escape(word, '/\\')
    local escaped_replacement = vim.fn.escape(replacement, '/\\')

    -- Déterminer si on est en mode visuel
    local mode = vim.fn.mode()

    if mode == 'v' or mode == 'V' then
        -- Mode visuel : substituer dans la sélection (toutes les occurrences, pas seulement les mots entiers)
        vim.cmd("'<,'>s/" .. escaped_word .. '/' .. escaped_replacement .. '/g')
    else
        -- Mode normal : substituer sur la ligne courante (toutes les occurrences)
        vim.cmd('s/' .. escaped_word .. '/' .. escaped_replacement .. '/g')
    end

    -- Effacer le highlight de recherche
    vim.cmd 'nohlsearch'
end

-- Configuration des keymaps
vim.keymap.set('n', '<leader>sw', substitute_word, {
    desc = '[S]ubstitute [W]ord (single occurrence per line, current line)',
    noremap = true,
    silent = true,
})

vim.keymap.set('v', '<leader>sw', substitute_word, {
    desc = '[S]ubstitute [W]ord (single occurrence per line, selection)',
    noremap = true,
    silent = true,
})

vim.keymap.set('n', '<leader>sa', substitute_word_all, {
    desc = '[S]ubstitute [A]ll occurrences (current line)',
    noremap = true,
    silent = true,
})

vim.keymap.set('v', '<leader>sa', substitute_word_all, {
    desc = '[S]ubstitute [A]ll occurrences (selection)',
    noremap = true,
    silent = true,
})

return {}
