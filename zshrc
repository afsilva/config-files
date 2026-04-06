# ============================================================================
# .zshrc - Zsh configuration for interactive shells
# ============================================================================

setopt NOInteractiveComments

#------------------------------------------------------------------------------#
# HISTORY SETTINGS -----------------------------------------------------------
#------------------------------------------------------------------------------#
HISTFILE=~/.history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS

#------------------------------------------------------------------------------#
# SHELL OPTIONS --------------------------------------------------------------
#------------------------------------------------------------------------------#
setopt AUTO_CD EXTENDED_GLOB INTERACTIVE_COMMENTS PROMPT_SUBST
setopt NO_BEEP ALWAYS_TO_END COMPLETE_IN_WORD NOMATCH

#------------------------------------------------------------------------------#
# KEY BINDINGS ---------------------------------------------------------------
#------------------------------------------------------------------------------#
bindkey -e
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\eOc" emacs-forward-word
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
bindkey "\e[1;3C" forward-word
bindkey "\e[1;3D" backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey '^I' expand-or-complete-prefix
bindkey '^H' backward-delete-word

#------------------------------------------------------------------------------#
# COMPLETION SYSTEM ----------------------------------------------------------
#------------------------------------------------------------------------------#
autoload -Uz compinit && compinit

_force_rehash() { (( CURRENT == 1 )) && rehash; return 1; }

zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select=2
zstyle ':completion:*:approximate:' max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3)) numeric )'
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*~'
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zcompdump.cache
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion::complete:cd::' tag-order local-directories
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true

#------------------------------------------------------------------------------#
# ENVIRONMENT VARIABLES ------------------------------------------------------
#------------------------------------------------------------------------------#
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
export CDPATH=.:~:~/Projects:~/Documents
export EDITOR=vim VISUAL=vim PAGER=less LESS="-RfM"
export LANG=${LANG:-en_US.UTF-8} LC_ALL=${LC_ALL:-en_US.UTF-8}

if [[ $EUID -eq 0 ]]; then umask 0022; else umask 0002; fi

#------------------------------------------------------------------------------#
# COLORS ----------------------------------------------------------------------
#------------------------------------------------------------------------------#
autoload -U colors && colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval "PR_${COLOR}='%{\\$fg[${(L)COLOR}]%}'"
    eval "PR_BRIGHT_${COLOR}='%{\\$fg_bold[${(L)COLOR}]%}'"
done
PR_RESET='%{$reset_color%}'

if [ ! -s ~/.dir_colors ]; then dircolors -p > ~/.dir_colors 2>/dev/null; fi
eval "$(dircolors ~/.dir_colors 2>/dev/null)"

#------------------------------------------------------------------------------#
# ALIASES: File Operations ---------------------------------------------------
#------------------------------------------------------------------------------#
alias ls='ls --color=auto'
alias ll='ls -lAh --group-directories-first --color=auto'
alias la='ls -A --color=auto'
alias lS='ls -lSh --group-directories-first --color=auto'
alias lt='ls -lth --group-directories-first --color=auto'
alias lr='ls -ltr --group-directories-first --color=auto'
alias lx='ls -lX --group-directories-first --color=auto'
alias sl='ls -lAh --group-directories-first --color=auto'
alias d='ls -lX --group-directories-first --color=auto'

alias ..='cd ..' alias ...='cd ../..' alias ....='cd ../../..'

#------------------------------------------------------------------------------#
# ALIASES: Search & System ---------------------------------------------------
#------------------------------------------------------------------------------#
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ps='ps -ef'

alias dfh='df -h' alias duh='du -sh'

#------------------------------------------------------------------------------#
# ALIASES: Git ---------------------------------------------------------------
#------------------------------------------------------------------------------#
alias gs='git status' alias gd='git diff' alias gdf='git diff --cached'
alias gc='git commit -m "${1:-}"' alias gp='git push'
alias gl='git pull' alias ga='git add' alias gb='git branch'

#------------------------------------------------------------------------------#
# GIT SHORTLOG FUNCTION ------------------------------------------------------
#------------------------------------------------------------------------------#
g() {
    if [[ -d .git ]] || git rev-parse --is-inside-work-tree &>/dev/null; then
        git log --oneline --graph --decorate -20
    else
        echo "Not in a git repository"
        return 1
    fi
}

#------------------------------------------------------------------------------#
# VCS_INFO - Git branch in prompt (WORKING SOLUTION) -------------------------
#------------------------------------------------------------------------------#
autoload -Uz vcs_info

# Enable git tracking
zstyle ':vcs_info:*' enable git

# Format: yellow branch name with leading space
zstyle ':vcs_info:git:*' formats ' %F{yellow}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{red}%b%f'

# Call vcs_info with 'prompt' argument to enable %b in prompt context
precmd() {
    vcs_info 'prompt'
}

#------------------------------------------------------------------------------#
# PROMPT ----------------------------------------------------------------------
#------------------------------------------------------------------------------#
PROMPT='%F{blue}%n@%m%f %F{green}~%f${PWD:#$HOME}/%(?:%f:%F{red})%f %{$reset_color%}%F{cyan}\$%f '

# RPS1 shows date/time and git branch (if in a repo)
RPS1='%F{white}%D{%Y-%m-%d %H:%M:%S}%f %?${vcs_info_msg_0_}'

#------------------------------------------------------------------------------#
# USEFUL FUNCTIONS -----------------------------------------------------------
#------------------------------------------------------------------------------#
httpd() {
    local port=${1:-8000}
    echo "Starting HTTP server on http://localhost:$port"
    python3 -m http.server "$port" 2>/dev/null || python -m SimpleHTTPServer "$port"
}

dus() {
    du -sh * 2>/dev/null | sort -rh | head -${1:-10}
}

clean-orig() {
    find . -name "*.orig" -type f -delete
}

cd ~
echo "Zsh initialized. Happy hacking!"
