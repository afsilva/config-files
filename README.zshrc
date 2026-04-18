# Zsh Configuration Guide

This file documents the accompanying `zshrc` in this directory. The config is focused on an interactive shell with large shared history, convenient key bindings, richer completion, a two-line prompt, and a small set of aliases/functions.

## Startup Defaults

- Stores history in `${ZDOTDIR:-$HOME}/.histfile`.
- Keeps 50,000 commands in memory and saves 50,000 commands on disk.
- Treats `/` and `.` as word separators for word-motion editing.
- Uses `vim` as the default editor unless `EDITOR` is already set.
- Enables colored `ls` output with `CLICOLOR=1`.
- Adds `$HOME/bin` to `path`.
- Sets `cdpath` to the current directory, `$HOME`, and `$HOME/git`.
- Uses `umask 0022` for root and `umask 0002` for non-root users.

## Shell Options

The config enables these common interactive behaviors:

- `append_history`, `inc_append_history`, `share_history`: keep history current across shells.
- `hist_ignore_dups`, `hist_ignore_space`: skip duplicate commands and commands that start with a space.
- `auto_cd`: enter a directory by typing its path.
- `auto_list`, `auto_menu`, `complete_in_word`: make tab completion more helpful and allow completion in the middle of words.
- `extended_glob`: enable Zsh's extended glob patterns.
- `no_beep`, `no_nomatch`: avoid terminal beeps and leave unmatched globs unchanged.
- `notify`: report background job status immediately.
- `prompt_subst`: allow command and parameter expansion inside prompts.

## Key Bindings

The shell uses Emacs-style line editing with `bindkey -e`.

| Keys | Action |
| --- | --- |
| Home / End | Move to beginning or end of line |
| Page Up / Page Down | Move to beginning or end of history |
| Delete | Delete character under the cursor |
| Insert | Toggle overwrite mode |
| Ctrl+Right / Ctrl+Left | Move forward or backward one word |
| Alt+Right / Alt+Left | Move forward or backward one word |
| Tab | Complete from the current cursor position |

Extra Home/End bindings are included for rxvt, xterm variants, and FreeBSD console escape sequences.

## Completion

Completion is initialized with `compinit` and a cached dump file under:

```zsh
${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}
```

Notable completion behavior:

- Tries existing lists, expansion, command rehashing, normal completion, and approximate correction.
- Rehashes commands automatically when completing the first word of a command.
- Allows approximate matches, roughly one error for every three typed characters.
- Matches uppercase letters from lowercase input.
- Groups and describes matches with verbose completion output.
- Uses `$LS_COLORS` for completion colors when available.
- Ignores backup files as executable command completions.
- Ignores completion functions beginning with `_` when completing normal commands.
- Uses a completion cache in `${XDG_CACHE_HOME:-$HOME/.cache}/zsh`.
- Avoids offering the current directory or parent as `cd` completions.
- Uses selectable menus for completion lists, directory stack completion, manual pages, and process killing.

Manual page completion is configured to separate and insert manual sections, so `man printf<Tab>` can distinguish between different sections when available.

## Aliases

### Listing Files

| Alias | Command |
| --- | --- |
| `ls` | `ls -G` |
| `sl` | `ls -lah` |
| `l` | `ls -lah` |
| `d` | `ls -lhX` |
| `ll` | `ls -lhX` |
| `la` | `ls -A` |
| `ldir` | `ls -lhA | grep '^d'` |
| `lfiles` | `ls -lhA | grep "^-"` |

### Search and Editing

| Alias | Command |
| --- | --- |
| `grep` | `grep --color=auto` |
| `egrep` | `grep -E --color=auto` |
| `fgrep` | `grep -F --color=auto` |
| `vi` | `$EDITOR` |

### Navigation

| Alias | Command |
| --- | --- |
| `-` | `cd -` |
| `...` | `../..` |
| `....` | `../../..` |
| `.....` | `../../../..` |

### Global Aliases

These can expand anywhere in a command line:

| Alias | Expands to |
| --- | --- |
| `X` | `| xargs` |
| `G` | `| grep -E` |

Example:

```zsh
ls G '\.txt$'
```

expands to:

```zsh
ls | grep -E '\.txt$'
```

## Functions

### `lss PATTERN`

Lists files by modification time and filters the output with `grep`.

```zsh
lss report
```

Runs:

```zsh
ls -lrt | grep -- report
```

### `pss PATTERN`

Lists processes and filters the output with `grep`.

```zsh
pss ssh
```

Runs:

```zsh
ps -ef | grep -- ssh
```

### `ducks`

Shows the 16 largest visible and hidden items in the current directory. It first sorts entries by size in KiB, then prints human-readable sizes for the largest matches.

```zsh
ducks
```

### `show-colors`

Prints a 256-color terminal palette with color indexes.

```zsh
show-colors
```

## Prompt

The prompt uses Zsh color support plus `vcs_info` for Git branch information.

### First Line

Before each prompt, `precmd` prints a full-width status line.

Outside `screen`, it contains:

```text
[current-directory day, month date year]...[user@host]
```

Inside `screen`, it omits the date and prints:

```text
[current-directory]...[user@host]
```

The line uses blue brackets and yellow content, with box-drawing characters filling the space between the path/date and `user@host`.

### Prompt Line

Outside `screen`, the prompt includes the current time, a literal `$`, and Git status:

```text
└─[HH:MM $ git:(branch)]─>
```

Inside `screen`, the time is omitted:

```text
└─[ $ git:(branch)]─>
```

The prompt text color switches to green after the arrow, so typed commands appear green.

### Git Information

`vcs_info` is enabled for Git. When inside a Git repository, the prompt shows:

```text
 git:(branch)
```

During Git actions such as rebases or merges, the action is included:

```text
 git:(branch|action)
```

The config defines staged and unstaged markers, but change checking is currently disabled with:

```zsh
zstyle ':vcs_info:*:prompt:*' check-for-changes false
```

Because of that, branch names are shown without the `+` or `*` dirty-state markers.

## Terminal Titles

For xterm-like terminals, `preexec` updates the window title before each command:

- SSH commands set the title to the remote host plus the current directory.
- Other commands set the title to `user@host:current-directory`.

For `screen`, SSH commands update the screen window title using a shortened form of the remote host. A `precmd` hook named `set_screen_title` resets the screen title to the local host before each prompt.

## Reloading

After editing the installed `.zshrc`, reload it with:

```zsh
source ~/.zshrc
```

or start a new shell.
