-- lua/plugins/lsp.lua
-- LSP & language-specific plugins

return {
    -- ===============================
    -- Lua development helper
    -- ===============================
    {
        'folke/lazydev.nvim',
        ft = 'lua', -- load only for Lua files
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },

    -- ===============================
    -- Java LSP
    -- ===============================
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java', -- load only for Java files
        config = function()
            -- Determine the Java LSP executable and project root
            local cmd = { vim.fn.expand '~/.local/share/nvim/mason/bin/jdtls' }
            local root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1])

            -- Start or attach jdtls automatically for Java files
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'java',
                callback = function()
                    require('jdtls').start_or_attach {
                        cmd = cmd,
                        root_dir = root_dir,
                    }
                end,
            })
        end,
    },

    -- ===============================
    -- Main LSP Configuration
    -- ===============================
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Mason: install LSPs and related tools
            -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
            { 'williamboman/mason.nvim', opts = {} },
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- LSP status updates
            { 'j-hui/fidget.nvim', opts = {} },

            -- Extra capabilities for nvim-cmp
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            -- ========================================
            -- LSP Capabilities for nvim-cmp
            -- ========================================
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            -- ===============================
            -- Define LSP servers and settings
            -- ===============================
            local servers = {
                clangd = {},
                jdtls = {},
                pylsp = {
                    settings = {
                        pylsp = {
                            plugins = {
                                pyflakes = { enabled = false },
                                pycodestyle = {
                                    enabled = true,
                                    maxLineLength = 120, -- Passer de 79 à 120
                                },
                                autopep8 = { enabled = false },
                                yapf = { enabled = false },
                                mccabe = { enabled = false },
                                pylsp_mypy = { enabled = false },
                                pylsp_black = { enabled = false },
                                pylsp_isort = { enabled = false },
                                flake8 = { enabled = false },
                            },
                        },
                    },
                },
                cobol_ls = {},
                rust_analyzer = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = { callSnippet = 'Replace' },
                        },
                    },
                },
            }

            -- ===============================
            -- Ensure LSP tools are installed
            -- ===============================
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format Lua code
                'clang-format', -- Used to format C/Cpp
                'codelldb', -- Used for debug in C/Cpp
                'black', -- Used to format python
                'isort', -- Used to format python too
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            -- ========================================
            -- Mason-lspconfig setup
            -- ========================================
            require('mason-lspconfig').setup {
                ensure_installed = {},
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for ts_ls)
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }

            -- ========================================
            -- Helper to check if client supports a method
            -- ========================================
            -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
            ---@param client vim.lsp.Client
            ---@param method vim.lsp.protocol.Method
            ---@param bufnr? integer some lsp support methods only in specific files
            ---@return boolean
            local function client_supports_method(client, method, bufnr)
                if vim.fn.has 'nvim-0.11' == 1 then
                    return client:supports_method(method, bufnr)
                else
                    return client.supports_method(method, { bufnr = bufnr })
                end
            end

            -- ===============================
            -- LSP attach keymaps & autocommands
            -- ===============================
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    local builtin = require 'telescope.builtin'

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
                    -- Find references for the word under your cursor.
                    map('gr', builtin.lsp_references, '[G]oto [R]eferences')
                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- Get LSP client
                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    -- ========================
                    -- Document highlight autocommands
                    -- ========================
                    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })
                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                            end,
                        })
                    end

                    -- ========================
                    -- Inlay hints toggle
                    -- ========================
                    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            -- ===============================
            -- Diagnostics configuration
            -- ===============================
            vim.diagnostic.config {
                severity_sort = true,
                float = { border = 'rounded', source = 'if_many' },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '󰅚 ',
                        [vim.diagnostic.severity.WARN] = '󰀪 ',
                        [vim.diagnostic.severity.INFO] = '󰋽 ',
                        [vim.diagnostic.severity.HINT] = '󰌶 ',
                    },
                } or {},
                virtual_text = {
                    source = 'if_many',
                    spacing = 2,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            }
        end,
    },
}
