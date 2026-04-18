# ~/.zshrc - interactive shell setup

HISTFILE="${ZDOTDIR:-$HOME}/.histfile"
HISTSIZE=50000
SAVEHIST=50000
WORDCHARS="${WORDCHARS:s#/#}"
WORDCHARS="${WORDCHARS:s#.#}"
export EDITOR="${EDITOR:-vim}"
export CLICOLOR=1

# key bindings
bindkey -e
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" overwrite-mode
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
#Ctrl-left/right
bindkey '\e[1;5C' forward-word # ctrl right
bindkey '\e[1;5D' backward-word # ctrl left o
#alt-left/right
bindkey "\e[1;3C" forward-word 
bindkey "\e[1;3D" backward-word
#bindkey "^H" backward-delete-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, cant hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^I' expand-or-complete-prefix

setopt append_history auto_cd auto_list auto_menu complete_in_word
setopt extended_glob hist_ignore_dups hist_ignore_space inc_append_history
setopt no_beep no_nomatch notify prompt_subst share_history

autoload -Uz compinit

## completion system
_force_rehash() {
    (( CURRENT == 1 )) && rehash
    return 1
}

zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _approximate
zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )' # allow one error for every three characters typed in approximate completer
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~' # don't complete backup files as executables
zstyle ':completion:*:correct:*'       insert-unambiguous true             # start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}' #
zstyle ':completion:*:correct:*'       original true                       #
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}      # activate color-completion(!)
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'  # format on completion
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select              # complete 'cd -<tab>' with menu
#zstyle ':completion:*:expand:*'        tag-order all-expansions            # insert all expansions for expand completer
zstyle ':completion:*:history-words'   list false                          #
zstyle ':completion:*:history-words'   menu yes                            # activate menu
zstyle ':completion:*:history-words'   remove-all-dups yes                 # ignore duplicate entries
zstyle ':completion:*:history-words'   stop yes                            #
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'        # match uppercase from lowercase
zstyle ':completion:*:matches'         group 'yes'                         # separate matches into groups
zstyle ':completion:*'                 group-name ''
zstyle ':completion:*:messages'        format '%d'                         #
zstyle ':completion:*:options'         auto-description '%d'               #
zstyle ':completion:*:options'         description 'yes'                   # describe options in full
zstyle ':completion:*:processes'       command 'ps -au$USER'               # on processes completion complete all user processes
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters        # offer indexes before parameters in subscripts
zstyle ':completion:*'                 verbose true                        # provide verbose completion information
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d' # set format for warnings
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'       # define files to ignore for zcompile
zstyle ':completion:correct:'          prompt 'correct to: %e'             #
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'    # Ignore completion functions for commands you don't have:

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select



# Completion caching
zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d $zsh_cache_dir ]] || mkdir -p -- "$zsh_cache_dir"
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$zsh_cache_dir"
zstyle ':completion:*:cd:*' ignore-parents parent pwd

zstyle ':completion::complete:cd::' tag-order local-directories
zstyle ':completion:*' menu select=2
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

compinit -d "$zsh_cache_dir/zcompdump-${ZSH_VERSION}"
unset zsh_cache_dir

typeset -U path cdpath
path+=("$HOME/bin")
cdpath=(. "$HOME" "$HOME/git")

# I want my umask 0002 if I'm not root.
if [[ $EUID -eq 0 ]]; then
    umask 0022
else
    umask 0002
fi

#aliases
alias ls='ls -G'
alias sl='ls -lah'
alias l='ls -lah'
alias d='ls -lhX'
alias ll='ls -lhX'
alias la='ls -A'
alias ldir="ls -lhA | grep '^d'"
alias lfiles='ls -lhA | grep "^-"'

lss() {
    ls -lrt | grep -- "${1:?usage: lss PATTERN}"
}

pss() {
    ps -ef | grep -- "${1:?usage: pss PATTERN}"
}

ducks() {
    local item
    for item in ./*(N) ./.??*(N); do
        [[ ${item:t} == .. ]] && continue
        du -ks -- "$item"
    done | sort -rn | head -16 | while read -r _ item; do
        du -hs -- "$item"
    done
}

alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'
alias vi="$EDITOR"
alias -- -='cd -'
alias  ...='../..'
alias  ....='../../..'
alias  .....='../../../..'
alias -g X='| xargs'
alias -g G='| grep -E'

show-colors() {
    local line col code
    for line in {0..17}; do
        for col in {0..15}; do
            code=$((col * 18 + line))
            printf $'\e[38;05;%dm %03d' "$code" "$code"
        done
        print
    done
}

autoload -U colors && colors
PR_GREEN="%{$fg[green]%}"
PR_BRIGHT_RED="%{$fg_bold[red]%}"
PR_BRIGHT_YELLOW="%{$fg_bold[yellow]%}"
PR_RESET="%{${reset_color}%}"

setopt prompt_subst
 
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:prompt:*' check-for-changes false
zstyle ':vcs_info:*:prompt:*' unstagedstr "${PR_BRIGHT_YELLOW}*${PR_RESET}"
zstyle ':vcs_info:*:prompt:*' stagedstr "${PR_BRIGHT_YELLOW}+${PR_RESET}"
zstyle ':vcs_info:*:prompt:*' formats " ${PR_GREEN}%s${PR_RESET}:${PR_BRIGHT_RED}(%b)${PR_RESET}"
zstyle ':vcs_info:*:prompt:*' actionformats " ${PR_GREEN}%s${PR_RESET}:${PR_BRIGHT_RED}(%b|%a)${PR_RESET}"

case $TERM in
    *xterm*|rxvt|(dt|k|E)term)
        preexec () {
            if [[ $(basename ${1[(w)1]}) == "ssh" ]]; then
                SHN=${1[(w)-1]}
                SHN_ARRAY=( ${(s,.,)SHN})
                print -Pn "\e]2;$SHN:%~\a"
            else
                print -Pn "\e]2;%n@%m:%~\a"
            fi
        }
    ;;
    screen)
        preexec () { 
            if [[ $(basename ${1[(w)1]}) == "ssh" ]]; then
                SHN=${1[(w)-1]}
                SHN=${SHN#*@}
                SHN_ARRAY=( ${(s,.,)SHN})
                case ${#SHN_ARRAY} in
                    2)
                        print -Pn "\033k$SHN\033\\"
                    ;;
                    4)
                        print -Pn "\033k$SHN_ARRAY[1].$SHN_ARRAY[2]\033\\"
                    ;;
                    5)
                        #print -Pn "\033k$SHN_ARRAY[1].$SHN_ARRAY[2].$SHN_ARRAY[3]\033\\"
                        print -Pn "\033k$SHN_ARRAY[1].$SHN_ARRAY[3]\033\\"
                    ;;
                    *)
                        print -Pn "\033k$SHN_ARRAY[1]\033\\"
                    ;;
                esac
            fi
        }
        #set up precmd to draw the screen title
        function set_screen_title { 
            print -Pn "\033k%m\033\\"
        }
        precmd_functions=( set_screen_title )
    ;;
}

precmd(){
    local line1 line1_prompt user_host user_p fill_spaces
    local -i termwidth line1_length user_p_length

    vcs_info 'prompt'

    if [[ $TERM == "screen" ]]; then
        line1_prompt="%B%F{blue}[%f%b%F{yellow}%d%F{blue}]"
    else
        line1_prompt="%B%F{blue}[%f%b%F{yellow}%d %D{%a, %b %d %y}%f%B%F{blue}]"
    fi

    user_host="[%f%b%F{yellow}%n@%m%f%B%F{blue}]%f%b"

    (( termwidth = ${COLUMNS:-80} - 2 ))
    line1=${(e%)line1_prompt} user_p=${(e%)user_host}
    line1_length=${#${line1//\[[^m]##m/}}
    user_p_length=${#${user_p//\[[^m]##m/}}
    fill_spaces=${(l:termwidth - (line1_length + user_p_length)::─:)}

    print -- "$line1─$fill_spaces─$user_p"
}

if [[ $TERM == "screen" ]]; then
    PROMPT='%B%F{blue}└─[%f%b%F{yellow} \$%f%B%F{blue}${vcs_info_msg_0_}%B%F{blue} ]─> %f%b%F{green}'
else
    PROMPT='%B%F{blue}└─[%f%b%F{yellow}%D{%R} \$%f%B%F{blue}${vcs_info_msg_0_}%B%F{blue}]─> %f%b%F{green}'
fi

RPROMPT=
RPS1=
