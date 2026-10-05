-- lua/plugins/git.lua
-- Git-related plugins

return {
    {
        'lewis6991/gitsigns.nvim', -- Adds git signs to the gutter and utilities for managing changes
        opts = {
            signs = {
                add = { text = '+' }, -- sign for added lines
                change = { text = '~' }, -- sign for modified lines
                delete = { text = '_' }, -- sign for deleted lines
                topdelete = { text = '‾' }, -- sign for top-line deletions
                changedelete = { text = '~' }, -- sign for modified+deleted lines
            },
            current_line_blame = true, -- enable inline blame by default
            current_line_blame_opts = {
                delay = 500, -- delay in ms before showing blame
                virt_text_pos = 'eol', -- position : 'eol' | 'overlay' | 'right_align'
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>tb', require('gitsigns').toggle_current_line_blame, {
                    buffer = bufnr,
                    desc = '[T]oggle git [B]lame line',
                })
            end,
        },
    },
    {
        'kdheepak/lazygit.nvim',
        cmd = 'LazyGit',
        keys = {
            { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'Open [L]azy[G]it' },
        },
    },
    {
        'sindrets/diffview.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = {
            'DiffviewOpen',
            'DiffviewClose',
            'DiffviewToggleFiles',
            'DiffviewFocusFiles',
            'DiffviewRefresh',
            'DiffviewFileHistory',
        },
        keys = {
            { '<leader>gdo', '<cmd>DiffviewOpen<cr>', desc = 'Ouvrir Diffview' },
            { '<leader>gdc', '<cmd>DiffviewClose<cr>', desc = 'Fermer Diffview' },
            { '<leader>gdh', '<cmd>DiffviewFileHistory<cr>', desc = 'Historique (repo)' },
            { '<leader>gdf', '<cmd>DiffviewFileHistory %<cr>', desc = 'Historique (fichier courant)' },
            { '<leader>gdf', ":'<,'>DiffviewFileHistory<cr>", mode = 'v', desc = 'Historique (sélection)' },
            { '<leader>gdr', '<cmd>DiffviewRefresh<cr>', desc = 'Rafraîchir Diffview' },
            { '<leader>gdm', '<cmd>DiffviewOpen main...HEAD<cr>', desc = 'Diff vs main' },
            { '<leader>gdM', '<cmd>DiffviewOpen HEAD~1<cr>', desc = 'Diff vs dernier commit' },
        },
        config = function()
            local actions = require 'diffview.actions'

            require('diffview').setup {
                diff_binaries = false,
                enhanced_diff_hl = true,
                git_cmd = { 'git' },
                use_icons = true,
                watch_index = true,

                view = {
                    default = {
                        layout = 'diff2_horizontal',
                    },
                    merge_tool = {
                        layout = 'diff3_horizontal',
                        disable_diagnostics = true,
                    },
                    file_history = {
                        layout = 'diff2_horizontal',
                    },
                },

                file_panel = {
                    listing_style = 'tree',
                    tree_options = {
                        flatten_dirs = true,
                        folder_statuses = 'only_folded',
                    },
                    win_config = {
                        position = 'left',
                        width = 35,
                    },
                },

                file_history_panel = {
                    log_options = {
                        git = {
                            single_file = { diff_merges = 'combined' },
                            multi_file = { diff_merges = 'first-parent' },
                        },
                    },
                    win_config = {
                        position = 'bottom',
                        height = 16,
                    },
                },

                keymaps = {
                    disable_defaults = false, -- garde les defaults, on ajoute/écrase juste ce qu'on veut

                    view = {
                        -- Navigation entre fichiers modifiés
                        { 'n', '<tab>', actions.select_next_entry, { desc = 'Fichier suivant' } },
                        { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Fichier précédent' } },
                        { 'n', 'gf', actions.goto_file_edit, { desc = 'Ouvrir le fichier (édition)' } },
                        { 'n', '<C-w><C-f>', actions.goto_file_split, { desc = 'Ouvrir le fichier (split)' } },
                        { 'n', '<C-w>gf', actions.goto_file_tab, { desc = 'Ouvrir le fichier (nouvel onglet)' } },
                        { 'n', '<leader>e', actions.focus_files, { desc = 'Focus panneau fichiers' } },
                        { 'n', '<leader>b', actions.toggle_files, { desc = 'Afficher/cacher panneau fichiers' } },
                        { 'n', 'g<C-x>', actions.cycle_layout, { desc = 'Changer la mise en page' } },
                        { 'n', '[x', actions.prev_conflict, { desc = 'Conflit précédent' } },
                        { 'n', ']x', actions.next_conflict, { desc = 'Conflit suivant' } },
                        { 'n', '<leader>co', actions.conflict_choose 'ours', { desc = 'Résoudre: ours' } },
                        { 'n', '<leader>ct', actions.conflict_choose 'theirs', { desc = 'Résoudre: theirs' } },
                        { 'n', '<leader>cb', actions.conflict_choose 'base', { desc = 'Résoudre: base' } },
                        { 'n', '<leader>ca', actions.conflict_choose 'all', { desc = 'Résoudre: tout' } },
                        { 'n', 'dx', actions.conflict_choose 'none', { desc = 'Supprimer la région conflictuelle' } },
                        { 'n', 'g?', actions.help 'view', { desc = 'Aide' } },
                        {
                            'n',
                            '<leader>dt',
                            function()
                                vim.wo.diff = not vim.wo.diff
                            end,
                            { desc = 'Toggle diff highlighting (fenêtre courante)' },
                        },
                    },

                    file_panel = {
                        { 'n', 'j', actions.next_entry, { desc = 'Entrée suivante' } },
                        { 'n', 'k', actions.prev_entry, { desc = 'Entrée précédente' } },
                        { 'n', '<cr>', actions.select_entry, { desc = 'Ouvrir le diff' } },
                        { 'n', 'o', actions.select_entry, { desc = 'Ouvrir le diff' } },
                        { 'n', '<2-LeftMouse>', actions.select_entry, { desc = 'Ouvrir le diff' } },
                        { 'n', '-', actions.toggle_stage_entry, { desc = 'Stage/unstage' } },
                        { 'n', 'S', actions.stage_all, { desc = 'Stage tout' } },
                        { 'n', 'U', actions.unstage_all, { desc = 'Unstage tout' } },
                        { 'n', 'X', actions.restore_entry, { desc = 'Restaurer (discard)' } },
                        { 'n', 'R', actions.refresh_files, { desc = 'Rafraîchir la liste' } },
                        { 'n', 'L', actions.open_commit_log, { desc = 'Voir le commit' } },
                        { 'n', 'zo', actions.open_fold, { desc = 'Ouvrir le dossier' } },
                        { 'n', 'zc', actions.close_fold, { desc = 'Fermer le dossier' } },
                        { 'n', 'za', actions.toggle_fold, { desc = 'Toggle dossier' } },
                        { 'n', 'zR', actions.open_all_folds, { desc = 'Tout déplier' } },
                        { 'n', 'zM', actions.close_all_folds, { desc = 'Tout replier' } },
                        { 'n', '<tab>', actions.select_next_entry, { desc = 'Fichier suivant' } },
                        { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Fichier précédent' } },
                        { 'n', 'gf', actions.goto_file_edit, { desc = 'Ouvrir le fichier' } },
                        { 'n', 'i', actions.listing_style, { desc = 'Style liste/arbre' } },
                        { 'n', 'f', actions.toggle_flatten_dirs, { desc = 'Aplatir les dossiers' } },
                        { 'n', '<leader>e', actions.focus_files, { desc = 'Focus panneau fichiers' } },
                        { 'n', '<leader>b', actions.toggle_files, { desc = 'Toggle panneau fichiers' } },
                        { 'n', 'g?', actions.help 'file_panel', { desc = 'Aide' } },
                    },

                    file_history_panel = {
                        { 'n', 'g!', actions.options, { desc = 'Options de log' } },
                        { 'n', '<C-A-d>', actions.open_in_diffview, { desc = 'Ouvrir dans une diffview' } },
                        { 'n', 'y', actions.copy_hash, { desc = 'Copier le hash du commit' } },
                        { 'n', 'L', actions.open_commit_log, { desc = 'Voir le commit' } },
                        { 'n', 'zR', actions.open_all_folds, { desc = 'Tout déplier' } },
                        { 'n', 'zM', actions.close_all_folds, { desc = 'Tout replier' } },
                        { 'n', 'j', actions.next_entry, { desc = 'Entrée suivante' } },
                        { 'n', 'k', actions.prev_entry, { desc = 'Entrée précédente' } },
                        { 'n', '<cr>', actions.select_entry, { desc = 'Ouvrir le diff' } },
                        { 'n', 'o', actions.select_entry, { desc = 'Ouvrir le diff' } },
                        { 'n', '<tab>', actions.select_next_entry, { desc = 'Suivant' } },
                        { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Précédent' } },
                        { 'n', 'g?', actions.help 'file_history_panel', { desc = 'Aide' } },
                    },

                    option_panel = {
                        { 'n', '<tab>', actions.select_entry, { desc = "Changer l'option" } },
                        { 'n', 'q', actions.close, { desc = 'Fermer' } },
                    },

                    help_panel = {
                        { 'n', 'q', actions.close, { desc = "Fermer l'aide" } },
                        { 'n', '<esc>', actions.close, { desc = "Fermer l'aide" } },
                    },
                },
            }

            -- Intégration which-key (v3)
            local ok, wk = pcall(require, 'which-key')
            if ok then
                wk.add {
                    { '<leader>gd', group = 'Diffview' },
                    { '<leader>gdo', desc = 'Ouvrir Diffview' },
                    { '<leader>gdc', desc = 'Fermer Diffview' },
                    { '<leader>gdh', desc = 'Historique (repo)' },
                    { '<leader>gdf', desc = 'Historique (fichier courant)' },
                    { '<leader>gdr', desc = 'Rafraîchir' },
                    { '<leader>gdm', desc = 'Diff vs main' },
                    { '<leader>gdM', desc = 'Diff vs dernier commit' },
                    { '<leader>dt', desc = 'Toggle diff highlighting' },
                }
            end
        end,
    },
}
