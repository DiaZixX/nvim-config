-- lua/plugins/remote.lua
-- Remote development: edit the files of a (libvirt) VM from the host Neovim,
-- as if they were local, with the *VM's* clangd (so absolute include paths in
-- compile_commands.json are valid).
--
--   remote-sshfs.nvim : mounts the WHOLE VM filesystem (`/`) locally through sshfs.
--                       sshfs is lazy: nothing is transferred until a file is accessed.
--   remote-lsp.nvim   : runs the LSP server inside the VM over ssh.
--   scripts/remote-lsp-proxy.py : path translation  <mount>/x  <->  /x   (VM path)
--
-- Because the whole VM is mounted, EVERY path clangd reports (project, /usr/include,
-- /usr/src, kernel headers...) is a normal, openable file: `gd` just works.
--
-- Setup guide (VM, ssh config, libvirt): docs/remote-vm.md
--
-- Keymaps (prefix <leader>R):
--   <leader>Rc  connect (pick a host from ~/.ssh/config) and :cd into its project
--   <leader>Rd  disconnect (stops remote LSP clients first)
--   <leader>Re  edit ssh config
--   <leader>Rf  find files  (runs `find` ON the VM: fast)
--   <leader>Rg  live grep   (runs `grep` ON the VM: fast)
--   <leader>Ri  show what is connected / which LSP command runs (debug)
--   <leader>Rl  tail the remote-lsp proxy log (debug)

-- ===============================
-- Helpers
-- ===============================

-- Servers run ON THE VM through ssh. `cmd` is joined by the proxy into ONE shell
-- string: quote anything with spaces or globs.
local remote_servers = {
    clangd = {
        cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--completion-style=detailed',
            '--header-insertion=iwyu',
            -- compile_commands.json elsewhere than the project root / build/ ?
            -- '--compile-commands-dir=/home/dev/project/build',
            -- cross-compiler in compile_commands.json ?
            -- "--query-driver='/usr/bin/*-gcc,/opt/**/bin/*-g++'",
        },
    },
    -- Other servers of your lsp.lua can be moved to the VM the same way:
    -- rust_analyzer = { cmd = 'rust-analyzer' },
    -- pylsp = { cmd = 'pylsp' },
}

-- Hard-coded in remote-lsp's lsp-proxy.py
local proxy_log_dir = vim.fn.expand '~/.cache/nvim/remote_lsp_logs'

-- The proxy writes one *DEBUG* log (every LSP message) per launch: they grow
-- fast, so we drop the old ones each time the plugin is loaded.
local function prune_proxy_logs(max_age_days)
    local limit = os.time() - max_age_days * 86400
    local ok, iter = pcall(vim.fs.dir, proxy_log_dir)
    if not ok or not iter then
        return
    end
    for name, kind in iter do
        if kind == 'file' and name:match '^proxy_log_.*%.log$' then
            local path = proxy_log_dir .. '/' .. name
            local st = vim.uv.fs_stat(path)
            if st and st.mtime.sec < limit then
                vim.uv.fs_unlink(path)
            end
        end
    end
end

local function tail_latest_proxy_log()
    local logs = vim.fn.glob(proxy_log_dir .. '/proxy_log_*.log', false, true)
    if #logs == 0 then
        vim.notify('[remote-lsp] No proxy log yet (open a C/C++ file on the mount first)', vim.log.levels.WARN)
        return
    end
    table.sort(logs) -- names embed a timestamp -> last = newest
    vim.cmd('botright 15split | terminal tail -n 200 -f ' .. vim.fn.shellescape(logs[#logs]))
end

-- Reads the `# Project=/abs/path/in/the/vm` comment of the host's block in the
-- ssh config (same trick as the plugin's `# Path=`), e.g.
--     Host vmdev 192.168.122.87
--         ...
--     # Path=/
--     # Project=/home/dev/project
local function project_dir(host)
    if not host.Config then
        return nil
    end
    local current, found = {}, nil
    for line in io.lines(vim.fn.expand(host.Config)) do
        local names = line:match '^%s*Host%s+(.+)$'
        if names then
            current = {}
            for n in names:gmatch '%S+' do
                current[n] = true
            end
        end
        local proj = line:match '^%s*#%s*Project=(%S+)'
        if proj and current[host.Name] then
            found = proj
        end
    end
    return found
end

-- Stop remote LSP clients, then unmount. Otherwise the remote clangd keeps
-- running (and its ssh connection stays open) on a mount that no longer exists.
local function disconnect()
    for _, client in ipairs(vim.lsp.get_clients()) do
        if client.name:match '^remote%-' then
            client:stop()
        end
    end
    require('remote-sshfs.api').disconnect()
end

local function info()
    local ok, conn = pcall(require, 'remote-sshfs.connections')
    local lines = {}
    if not (ok and conn.is_connected()) then
        lines[#lines + 1] = 'sshfs: not connected'
    else
        local host = conn.get_current_host()
        lines[#lines + 1] = ('sshfs: %s -> %s'):format(host.Name, conn.get_current_mount_point())
        lines[#lines + 1] = ('ssh config: Path=%s'):format(host.Path or '(none: /home/<User> is mounted)')
    end
    local clients = vim.lsp.get_clients { bufnr = 0 }
    if #clients == 0 then
        lines[#lines + 1] = 'LSP: no client attached to this buffer'
    end
    for _, c in ipairs(clients) do
        lines[#lines + 1] = ('LSP: %s (root %s)'):format(c.name, tostring(c.config.root_dir))
        if c.name:match '^remote%-' then
            lines[#lines + 1] = '  cmd: ' .. table.concat(c.config.cmd, ' ')
        end
    end
    lines[#lines + 1] = 'buffer: ' .. vim.api.nvim_buf_get_name(0)
    vim.notify(table.concat(lines, '\n'))
end

-- ===============================
-- Plugin specs
-- ===============================
return {
    -- sshfs mount (never loaded alone: pulled in by remote-lsp below)
    {
        'nosduco/remote-sshfs.nvim',
        lazy = true,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            require('remote-sshfs').setup {
                connections = {
                    -- Only the user's file: /etc/ssh/ssh_config (default) adds noise
                    -- such as a fake "*" host in the picker.
                    ssh_configs = { vim.fn.expand '$HOME/.ssh/config' },
                    sshfs_args = {
                        '-o reconnect',
                        '-o ConnectTimeout=5',
                        '-o ServerAliveInterval=15',
                        '-o ServerAliveCountMax=3',
                        '-o idmap=user', -- VM uid/gid shown as yours
                        '-o auto_cache', -- revalidate cache on mtime change
                        '-o compression=no', -- local virtual network: CPU > bandwidth
                        -- Absolute symlinks of the VM (/lib -> /usr/lib, build dirs...)
                        -- become relative, so they stay valid inside the mount.
                        '-o transform_symlinks',
                    },
                },
                mounts = {
                    -- MUST keep the trailing slash (remote-lsp compares path prefixes)
                    base_dir = vim.fn.expand '$HOME/.sshfs/',
                    unmount_on_exit = true,
                },
                handlers = {
                    on_connect = { change_dir = true }, -- :cd into the mount
                },
                ui = {
                    confirm = { connect = false, change_dir = false },
                    picker = 'telescope',
                },
            }
            -- Needed for :RemoteSSHFSConnect / Edit / FindFiles / LiveGrep pickers
            pcall(require('telescope').load_extension, 'remote-sshfs')
        end,
    },

    -- Remote LSP (entry point: loads remote-sshfs, then registers its hook)
    {
        'Chayanon-Ninyawee/remote-lsp.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'nosduco/remote-sshfs.nvim',
        },
        -- Lazy on purpose: until the first connection, your local LSP setup is
        -- completely untouched. Everything below triggers the load.
        cmd = {
            'RemoteSSHFSConnect',
            'RemoteSSHFSDisconnect',
            'RemoteSSHFSEdit',
            'RemoteSSHFSReload',
            'RemoteSSHFSFindFiles',
            'RemoteSSHFSLiveGrep',
        },
        keys = {
            {
                '<leader>Rc',
                function()
                    require('remote-sshfs.api').connect()
                end,
                desc = '[R]emote: [C]onnect',
            },
            { '<leader>Rd', disconnect, desc = '[R]emote: [D]isconnect' },
            {
                '<leader>Re',
                function()
                    require('remote-sshfs.api').edit()
                end,
                desc = '[R]emote: [E]dit ssh config',
            },
            {
                '<leader>Rf',
                function()
                    require('remote-sshfs.api').find_files()
                end,
                desc = '[R]emote: [F]ind files',
            },
            {
                '<leader>Rg',
                function()
                    require('remote-sshfs.api').live_grep()
                end,
                desc = '[R]emote: live [G]rep',
            },
            { '<leader>Ri', info, desc = '[R]emote: [I]nfo (debug)' },
            { '<leader>Rl', tail_latest_proxy_log, desc = '[R]emote: LSP proxy [L]og' },
        },
        config = function()
            prune_proxy_logs(3)

            -- Remote servers are clones of the local config (copied below), but
            -- make sure they get the nvim-cmp capabilities even if the local
            -- server is configured after this point.
            local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
            if ok then
                vim.lsp.config('*', {
                    capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities()),
                })
            end

            require('remote-lsp').setup {
                python_bin = 'python3',
                servers = remote_servers,
            }

            -- Registered AFTER remote-lsp's own on_connect_success hook, which has just
            -- set `cmd = { python, '-u', <plugin proxy>, ... }`: we swap in our wrapper
            -- around that same proxy (it handles a root mount, see header).
            local wrapper = vim.fn.stdpath 'config' .. '/scripts/remote-lsp-proxy.py'
            require('remote-sshfs').callback.on_connect_success:add(function(host, mount_dir)
                for name in pairs(remote_servers) do
                    local cfg = vim.lsp.config['remote-' .. name]
                    local cmd = vim.deepcopy(cfg.cmd)
                    table.insert(cmd, 3, wrapper) -- { python, -u, WRAPPER, <plugin proxy>, ... }
                    vim.lsp.config('remote-' .. name, { cmd = cmd })
                end

                -- Start in the project instead of the root of the VM
                local project = project_dir(host)
                if project then
                    vim.schedule(function()
                        local dir = mount_dir:gsub('/$', '') .. project
                        if vim.fn.isdirectory(dir) == 1 then
                            vim.cmd.cd(vim.fn.fnameescape(dir))
                            vim.notify('[remote] cwd: ' .. dir)
                        else
                            vim.notify('[remote] # Project=' .. project .. ' not found in the VM', vim.log.levels.WARN)
                        end
                    end)
                end
            end)
        end,
    },
}
