# Zsh Configuration Guide

This `.zshrc` file configures your interactive Zsh shell environment.

## Overview

- **History**: 50,000 commands with timestamps and deduplication
- **Auto CD**: Navigate directories without typing `cd`
- **Smart Completion**: Case-insensitive, typo-tolerant tab completion

---

## Shell Features

### Key Bindings
- Arrow keys, Home/End work correctly in all terminals
- Ctrl+Left/Right: Move word by word
- Alt+Left/Right: Move word by word  
- Ctrl+Backspace: Delete entire words

### Auto-Completion
- Tab completes commands, files, and directories
- Fuzzy matching allows typos (e.g., `g status` → `git status`)
- Case-insensitive matching

---

## Quick Reference: Aliases

### File Operations
| Alias | Description |
|-------|-------------|
| `ll` | Long listing, hidden files, directories first |
| `la` | Show hidden files |
| `lS` | Sort by size (largest first) |
| `lt` | Sort by time (newest first) |
| `lx` | Sort by file extension |
| `..`, `...`, `....` | Navigate up 1, 2, or 3 directories |

### Search & System
| Alias | Description |
|-------|-------------|
| `grep`, `egrep` | Colored output |
| `ps` | Full process listing (`ps -ef`) |
| `dfh` | Disk free, human-readable |
| `duh` | Disk usage, summary |

### Git
| Alias | Description |
|-------|-------------|
| `gs` | Status |
| `gd` | Diff (working tree) |
| `gdf` | Diff (staged) |
| `gp`, `gl` | Push / Pull |

---

## Custom Functions

### `g`
Show last 20 commits in a visual graph:
```bash
g    # git log --oneline --graph --decorate -20
```

### `httpd [port]`
Quick HTTP server:
```bash
httpd        # Serve on port 8000
httpd 3000   # Serve on port 3000
```

### `dus [count]`
Show largest directories:
```bash
dus         # Top 10 by size
dus 5       # Top 5 by size
```

### `clean-orig`
Remove `*.orig` backup files:
```bash
clean-orig
```

---

## Prompt Display

**Left side:** `user@host /path/to/dir $`
- Blue: username @ hostname
- Green/Red: current path (relative to home)
- Red path indicates previous command failed

**Right side:** `2024-01-15 10:30:45 0 main`
- Date and time
- Exit code of last command (0 = success)
- Git branch name (if in a repository)

---

## Applying Changes

After editing `.zshrc`, reload it:
```bash
source ~/.zshrc
```

Or restart your terminal.

---

## Customization Tips

### Add to PATH
```bash
export PATH="$HOME/mybin:$PATH"
```

### Add new alias
```bash
alias mycmd='actual command here'
```

### Add new function
```bash
myfunc() {
    # your code here
}
```

### Change prompt colors
Edit the `PROMPT` and `RPS1` variables. Color format: `%F{color}`

---

## Git Branch in Prompt

The prompt automatically shows your current git branch on the right side when you're inside a git repository. This is powered by Zsh's `vcs_info` module.

No action needed — it just works!
