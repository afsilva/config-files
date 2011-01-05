#!/bin/bash
# based on a function found in bashtstyle-ng 5.0b1
# Original author Christopher Roy Bratusek (http://www.nanolx.org)
# Last arranged by ayoli (http://ayozone.org) 2008-02-04 17:16:43 +0100 CET 

function pre_prompt {
newPWD="${PWD}"
user="whoami"
host=$(echo -n $HOSTNAME | sed -e "s/[\.].*//")
datenow=$(date "+%a, %d %b %y")
let promptsize=$(echo -n "┌($user@$host ddd., DD mmm YY)(${PWD})┐" \
                 | wc -c | tr -d " ")
let fillsize=${COLUMNS}-${promptsize}
fill=""
while [ "$fillsize" -gt "0" ] 
do 
    fill="${fill}─"
	let fillsize=${fillsize}-1
done
if [ "$fillsize" -lt "0" ]
then
    let cutt=3-${fillsize}
    newPWD="...$(echo -n $PWD | sed -e "s/\(^.\{$cutt\}\)\(.*\)/\2/")"
fi

}

PROMPT_COMMAND=pre_prompt

export black="\[\033[0;38;5;0m\]"
export red="\[\033[0;38;5;1m\]"
export orange="\[\033[0;38;5;130m\]"
export green="\[\033[0;38;5;2m\]"
export yellow="\[\033[0;38;5;3m\]"
export blue="\[\033[0;38;5;4m\]"
export bblue="\[\033[0;38;5;12m\]"
export magenta="\[\033[0;38;5;55m\]"
export cyan="\[\033[0;38;5;6m\]"
export white="\[\033[0;38;5;7m\]"
export coldblue="\[\033[0;38;5;33m\]"
export smoothblue="\[\033[0;38;5;111m\]"
export iceblue="\[\033[0;38;5;45m\]"
export turqoise="\[\033[0;38;5;50m\]"
export smoothgreen="\[\033[0;38;5;42m\]"



case "$TERM" in
xterm)
    PS1="$bblue┌─($orange\$newPWD \$(date \"+%a, %d %b %y\")$bblue)─\${fill}─($orange\u@\h\
$bblue)─┐\n$bblue└─($orange\$(date \"+%H:%M\") \$$bblue)─>$green "
    ;;
screen)
    PS1="$bblue┌─($orange\$newPWD \$(date \"+%a, %d %b %y\")$bblue)─\${fill}─($orange\u@\h\
$bblue)─┐\n$bblue└─($orange\$(date \"+%H:%M\") \$$bblue)─>$green "
    ;;    
    *)
    PS1="┌─(\$newPWD \$(date \"+%a, %d %b %y\"))─\${fill}─(\u@\h\
)─┐\n└─(\$(date \"+%H:%M\") \$)─> "
    ;;
esac

# bash_history settings: size and no duplicates and no lines w/ lead spaces
exportHISTCONTROL="ignoreboth"
export HISTSIZE=1024

# aliases #############################################

# enable color support of ls and also add handy aliases
eval `dircolors -b`
alias ls='ls --color=auto'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'

# some more ls aliases
alias d='ls -lhX'
alias ll='ls -lhX'
alias la='ls -A'
alias ldir='ls -lhA |grep ^d'
alias lfiles='ls -lhA |grep ^-'
#alias l='ls -CF'

# To see something coming into ls output: lss
alias lss='ls -lrt | grep $1'

# To check a process is running in a box with a heavy load: pss
alias pss='ps -ef | grep $1'

# usefull alias to browse your filesystem for heavy usage quickly
alias ducks='ls -A | grep -v -e '\''^\.\.$'\'' |xargs -i du -ks {} |sort -rn |head -16 | awk '\''{print $2}'\'' | xargs -i du -hs {}'

# cool colors for manpages
#alias man="TERMINFO=~/.terminfo TERM=mostlike LESS=C PAGER=less man"

##########################################################
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

