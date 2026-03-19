# nvim-config
Neovim configuration built from scratch with light inspiration from kickstart.nvim. Handpicked plugins, custom keymaps, and workflow optimizations tailored to my needs.

# Complete Neovim Keymaps Reference

> Configuration: Custom Neovim setup based on kickstart.nvim
> Leader Key: `<Space>`
> Last Updated: March 2026

---

## Table of Contents

1. [Core Keymaps](#core-keymaps)
2. [LSP - Language Server Protocol](#lsp---language-server-protocol)
3. [Telescope - Fuzzy Finder](#telescope---fuzzy-finder)
4. [Buffer Management](#buffer-management)
5. [Debug (DAP)](#debug-dap)
6. [Comments](#comments)
7. [Documentation (Neogen)](#documentation-neogen)
8. [Text Substitution](#text-substitution)
9. [File Explorer (Neo-tree)](#file-explorer-neo-tree)
10. [Code Formatting](#code-formatting)
11. [Treesitter Context](#treesitter-context)
12. [Quick Reference by Prefix](#quick-reference-by-prefix)

---

## Core Keymaps

*Location: `lua/core/keymaps.lua`*

### General
| Keymap | Mode | Description |
|--------|------|-------------|
| `<Esc>` | Normal | Clear search highlights |

### Diagnostics
| Keymap | Mode | Description |
|--------|------|-------------|
| `[d` | Normal | Go to previous diagnostic (with float) |
| `]d` | Normal | Go to next diagnostic (with float) |
| `<leader>e` | Normal | Show diagnostic [E]rror message |
| `<leader>q` | Normal | Open diagnostic [Q]uickfix list |

### Terminal
| Keymap | Mode | Description |
|--------|------|-------------|
| `<Esc><Esc>` | Terminal | Exit terminal mode |

### Window Navigation
| Keymap | Mode | Description |
|--------|------|-------------|
| `<C-h>` | Normal | Move focus to the left window |
| `<C-l>` | Normal | Move focus to the right window |
| `<C-j>` | Normal | Move focus to the lower window |
| `<C-k>` | Normal | Move focus to the upper window |

### File Explorer
| Keymap | Mode | Description |
|--------|------|-------------|
| `\` | Normal | Toggle Neo-tree panel (open/close without focusing) |

### Buffer Operations
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>x` | Normal | Delete current buffer (switches to previous buffer first) |

### Optional (hjkl Training)
| Keymap | Mode | Description |
|--------|------|-------------|
| `<left>` | Normal | Echo "Use h to move!" |
| `<right>` | Normal | Echo "Use l to move!" |
| `<up>` | Normal | Echo "Use k to move!" |
| `<down>` | Normal | Echo "Use j to move!" |

---

## LSP - Language Server Protocol

*Location: `lua/plugins/lsp.lua`*

### Code Navigation
| Keymap | Mode | Description |
|--------|------|-------------|
| `gd` | Normal | [G]oto [D]efinition (Telescope) |
| `gr` | Normal | [G]oto [R]eferences (Telescope) |
| `gI` | Normal | [G]oto [I]mplementation (Telescope) |
| `gD` | Normal | [G]oto [D]eclaration |

### Type & Symbol Information
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>D` | Normal | Type [D]efinition (Telescope) |
| `<leader>ds` | Normal | [D]ocument [S]ymbols (Telescope) |
| `<leader>ws` | Normal | [W]orkspace [S]ymbols (Telescope) |

### Code Actions
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>rn` | Normal | [R]e[n]ame symbol |
| `<leader>ca` | Normal, Visual | [C]ode [A]ction |

### Toggle Features
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>th` | Normal | [T]oggle Inlay [H]ints |

---

## Telescope - Fuzzy Finder

*Location: `lua/plugins/telescope.lua`*

### General Search
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>sh` | Normal | [S]earch [H]elp |
| `<leader>sk` | Normal | [S]earch [K]eymaps |
| `<leader>sf` | Normal | [S]earch [F]iles |
| `<leader>ss` | Normal | [S]earch [S]elect Telescope |
| `<leader>sw` | Normal | [S]earch current [W]ord |
| `<leader>sg` | Normal | [S]earch by [G]rep |
| `<leader>sd` | Normal | [S]earch [D]iagnostics |
| `<leader>sr` | Normal | [S]earch [R]esume |
| `<leader>s.` | Normal | [S]earch Recent Files |
| `<leader>sn` | Normal | [S]earch [N]eovim config files |

### Special Search
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader><leader>` | Normal | Find existing buffers |
| `<leader>/` | Normal | Fuzzy search in current buffer |
| `<leader>s/` | Normal | [S]earch in open files |

---

## Buffer Management

*Location: `lua/plugins/ui.lua` & `lua/core/keymaps.lua`*

### BufferLine Operations
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>bp` | Normal | [B]uffer [P]ick |
| `<leader>bc` | Normal | [B]uffer [C]lose (pick) |
| `<leader>bn` | Normal | [B]uffer [N]ext |
| `<leader>bb` | Normal | [B]uffer [B]ack |
| `<leader>b>` | Normal | [B]uffer Move [>] Right |
| `<leader>b<` | Normal | [B]uffer Move [<] Left |
| `<leader>bf` | Normal | [B]uffer Toggle [F]ix (Pin) |
| `<leader>x` | Normal | Delete current buffer |

---

## Debug (DAP)

*Location: `lua/plugins/debug.lua`*

### Debug Controls (Function Keys)
| Keymap | Mode | Description |
|--------|------|-------------|
| `<F5>` | Normal | Debug: Start/Continue |
| `<F1>` | Normal | Debug: Step Into |
| `<F2>` | Normal | Debug: Step Over |
| `<F3>` | Normal | Debug: Step Out |
| `<F7>` | Normal | Debug: Toggle UI |

### Breakpoints & Debug Actions
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>db` | Normal | [D]ebug toggle [B]reakpoint |
| `<leader>dB` | Normal | [D]ebug conditional [B]reakpoint |
| `<leader>dr` | Normal | [D]ebug open [R]EPL |
| `<leader>dl` | Normal | [D]ebug run [L]ast |

---

## Comments

*Location: `lua/plugins/comment.lua`*

### Toggle Comments
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>cc` | Normal | Toggle line [C]omment |
| `<leader>cb` | Normal | Toggle [B]lock comment |
| `<leader>cc` | Normal, Operator | [C]omment operator (e.g., `<leader>cc3j`) |
| `<leader>cb` | Normal, Operator | [B]lock comment operator |
| `<leader>cc` | Visual | Toggle linewise comment (visual) |
| `<leader>cb` | Visual | Toggle blockwise comment (visual) |

### Insert Comments
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>cO` | Normal | Add comment above |
| `<leader>co` | Normal | Add comment below |
| `<leader>cA` | Normal | Add comment end of line |

---

## Documentation (Neogen)

*Location: `lua/plugins/neogen.lua`*

### Generate Documentation
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>nf` | Normal | [N]eogen [F]unction documentation |
| `<leader>nc` | Normal | [N]eogen [C]lass documentation |
| `<leader>nt` | Normal | [N]eogen [T]ype documentation |
| `<leader>nF` | Normal | [N]eogen [F]ile documentation |
| `<leader>ng` | Normal | [N]eogen [G]enerate (auto context) |

---

## Text Substitution

*Location: `lua/plugins/substitute.lua`*

### Word Replacement
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>rw` | Normal | [R]eplace [W]ord (current line) |
| `<leader>rw` | Visual | [R]eplace [W]ord (selection) |
| `<leader>ra` | Normal | [R]eplace [A]ll occurrences (current line) |
| `<leader>ra` | Visual | [R]eplace [A]ll occurrences (selection) |

---

## File Explorer (Neo-tree)

*Location: `lua/plugins/neo-tree.lua` & `lua/core/keymaps.lua`*

### Neo-tree Controls
| Keymap | Mode | Description |
|--------|------|-------------|
| `\` | Normal | Toggle Neo-tree (open/close without focusing) |

### Inside Neo-tree Window
| Keymap | Context | Description |
|--------|---------|-------------|
| `<CR>` | Neo-tree | Open file in buffer |
| `<Tab>` | Neo-tree | Open file in new tab |
| `s` | Neo-tree | Open horizontal split |
| `v` | Neo-tree | Open vertical split |

---

## Code Formatting

*Location: `lua/plugins/conform.lua`*

### Formatting
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>f` | Normal, Visual | [F]ormat buffer |

---

## Treesitter Context

*Location: `lua/plugins/treesitter.lua`*

### Context Navigation
| Keymap | Mode | Description |
|--------|------|-------------|
| `[c` | Normal | Jump to context (sticky header) |

---

## Quick Reference by Prefix

### `<leader>s*` - Search (Telescope)
```
sh  → Help              sw  → Word
sk  → Keymaps           sg  → Grep
sf  → Files             sd  → Diagnostics
ss  → Select Telescope  sr  → Resume
s.  → Recent Files      sn  → Neovim files
s/  → Open Files        /   → Current buffer
```

### `<leader>b*` - Buffer
```
bp  → Pick              bn  → Next
bc  → Close (pick)      bb  → Back
b>  → Move Right        b<  → Move Left
bf  → Toggle Pin
```

### `<leader>d*` - Debug & Document
```
db  → Debug Breakpoint       ds  → Document Symbols
dB  → Debug Conditional      dr  → Debug REPL
dl  → Debug Run Last
```

### `<leader>c*` - Code & Comments
```
cc  → Comment Line/operator  ca  → Code Action
cb  → Comment Block/operator
cO  → Comment Above          co  → Comment Below
cA  → Comment End of Line
```

### `<leader>n*` - Neogen (Documentation)
```
nf  → Function doc      nc  → Class doc
nt  → Type doc          nF  → File doc
ng  → Generate auto
```

### `<leader>r*` - Rename & Replace
```
rn  → Rename symbol
rw  → Replace Word (current line / selection)
ra  → Replace All occurrences (current line / selection)
```

### `<leader>t*` - Toggle
```
th  → Toggle Inlay Hints
```

### `<leader>w*` - Workspace
```
ws  → Workspace Symbols
```

### `g*` - Go to (LSP)
```
gd  → Definition        gr  → References
gI  → Implementation    gD  → Declaration
```

### Function Keys - Debug
```
F1  → Step Into         F5  → Start/Continue
F2  → Step Over         F7  → Toggle UI
F3  → Step Out
```

### Window Navigation
```
<C-h>  → Left           <C-l>  → Right
<C-j>  → Down           <C-k>  → Up
```

---

## Statistics

- Total Keymaps: ~65 keymaps
- Leader Prefixes Used: 9 (`s, b, d, c, n, t, w, r, h`)
- Function Keys: 5 (F1-F3, F5, F7)
- No Conflicts: all resolved
- Most Used Prefix: `<leader>s*` (Search - 12 keymaps)

---

## Best Practices Applied

1. Mnemonic Consistency: Related actions share prefixes
2. No Overlaps: All conflicts resolved
3. Logical Grouping: Features grouped by category
4. Mode Awareness: Same keymap can work in multiple modes
5. Discoverability: Which-key integration for all leader keymaps

---

## Notes

- Leader Key: `<Space>` is set as the leader key
- Nerd Font: Some icons require Nerd Font to be installed
- Which-Key: Press `<leader>` and wait to see available keymaps
- Custom Functions: Some keymaps call custom Lua functions
- Buffer Delete: Switches to previous buffer before deleting to avoid Neo-tree expanding
- Neo-tree Toggle: `\` opens/closes the panel without stealing focus

---

*Generated from nvim-config analysis - March 2026*
