#!/usr/bin/env python3
"""Wrapper around remote-lsp.nvim's lsp-proxy.py: path translation for a ROOT mount.

remote-lsp.nvim's own translation breaks when the whole VM is mounted (remote prefix "/"):
it produces "//home/..." and mangles paths in the other direction. This wrapper loads the
plugin's proxy unchanged and only replaces its path-translation function, so plugin
updates keep working. Translation is direction-aware:
    neovim -> server : <sshfs mount>/x  ->  /x
    server -> neovim : /x               ->  <sshfs mount>/x

Usage (built by lua/plugins/remote.lua):
    remote-lsp-proxy.py <plugin lsp-proxy.py> <user@host> <sshfs_prefix> <remote_prefix> <cmd...>
"""

import importlib.util
import sys
import threading

_direction = threading.local()


def load_proxy(path):
    spec = importlib.util.spec_from_file_location("remote_lsp_proxy", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def starts_with_path(s, prefix):
    # prefix "" (remote root "/") matches every absolute path
    return s.startswith(prefix) and (len(s) == len(prefix) or s[len(prefix)] == "/")


def translate(s, src, dst):
    for scheme in ("file://", ""):
        if starts_with_path(s, scheme + src):
            return scheme + dst + s[len(scheme + src) :]
    return s


def main():
    plugin_proxy = sys.argv[1]
    proxy = load_proxy(plugin_proxy)

    orig_handle_stream = proxy.handle_stream

    def handle_stream(name, *args):
        _direction.name = name  # one thread per direction
        return orig_handle_stream(name, *args)

    def replace_paths(obj, sshfs_prefix, remote_prefix):
        local = sshfs_prefix.rstrip("/")
        remote = remote_prefix.rstrip("/")  # "/" -> ""
        to_remote = getattr(_direction, "name", "") == "neovim_to_ssh"
        src, dst = (local, remote) if to_remote else (remote, local)

        def walk(o):
            if isinstance(o, str):
                return translate(o, src, dst)
            if isinstance(o, dict):
                return {walk(k): walk(v) for k, v in o.items()}
            if isinstance(o, list):
                return [walk(i) for i in o]
            return o

        return walk(obj)

    # looked up at call time by the plugin's thread targets
    proxy.handle_stream = handle_stream
    proxy.replace_paths = replace_paths
    sys.argv = [plugin_proxy] + sys.argv[2:]
    proxy.main()


if __name__ == "__main__":
    main()
