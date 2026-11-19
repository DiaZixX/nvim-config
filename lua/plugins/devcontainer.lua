-- lua/plugins/devcontainer.lua
-- Dev containers depuis Neovim (https://github.com/esensar/nvim-dev-container)
--
-- Prérequis : Neovim 0.12+ et le parser treesitter `json` (:TSInstall json)

return {
    {
        'esensar/nvim-dev-container',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },

        -- Chargement paresseux : le plugin ne se charge que si on utilise ses commandes ou ses raccourcis
        cmd = {
            'DevcontainerStart',
            'DevcontainerAttach',
            'DevcontainerExec',
            'DevcontainerStop',
            'DevcontainerStopAll',
            'DevcontainerRemoveAll',
            'DevcontainerLogs',
            'DevcontainerEditNearestConfig',
        },

        keys = {
            { '<leader>Ds', '<Cmd>DevcontainerStart<CR>', desc = '[D]evcontainer [S]tart' },
            { '<leader>Da', '<Cmd>DevcontainerAttach<CR>', desc = '[D]evcontainer [A]ttach' },
            { '<leader>Dx', '<Cmd>DevcontainerStop<CR>', desc = '[D]evcontainer Stop (e[X]it)' },
            { '<leader>DX', '<Cmd>DevcontainerStopAll<CR>', desc = '[D]evcontainer Stop all' },
            { '<leader>Dl', '<Cmd>DevcontainerLogs<CR>', desc = '[D]evcontainer [L]ogs' },
            { '<leader>De', '<Cmd>DevcontainerEditNearestConfig<CR>', desc = '[D]evcontainer [E]dit config' },
        },

        config = function()
            require('devcontainer').setup {
                -- Runtime utilisé pour les conteneurs (par défaut le plugin essaie podman en premier)
                container_runtime = 'docker',

                -- Pas de démarrage/nettoyage automatique des conteneurs
                autocommands = {
                    init = false, -- démarrer à l'ouverture de nvim si un devcontainer.json existe
                    clean = false, -- supprimer conteneurs et images en quittant nvim
                    update = false, -- redémarrer si devcontainer.json change
                },

                -- Garde l'image avec Neovim installé dedans (l'installation est longue, une seule fois)
                cache_images = true,

                log_level = 'info',
            }
        end,
    },
}
