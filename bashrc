case $- in
    *i*) ;;
      *) return;;
esac

HISTSIZE=1000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# PS1 settings. using PRE and SUF for git status insertion
if [[ $EUID -ne 0 ]]; then
  PROMPT_PRE="\[\033[38;5;81m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;7m\]\H \[$(tput sgr0)\]\[\033[38;5;8m\]- \[$(tput sgr0)\]\[\033[38;5;244m\]\d \t - \[$(tput sgr0)\]\[\033[38;5;81m\]\$?"
  PROMPT_SUF="\n\[$(tput sgr0)\]\[\033[38;5;7m\]\w \[$(tput sgr0)\]\[\033[38;5;81m\]\\$ \[$(tput sgr0)\]"
else
  PROMPT_PRE="\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;7m\]\H \[$(tput sgr0)\]\[\033[38;5;8m\]- \[$(tput sgr0)\]\[\033[38;5;244m\]\d \t - \[$(tput sgr0)\]\[\033[38;5;9m\]\$?"
  PROMPT_SUF="\n\[$(tput sgr0)\]\[\033[38;5;7m\]\w \[$(tput sgr0)\]\[\033[38;5;9m\]# \[$(tput sgr0)\]"
fi

# insert git status if repo
PS1=$PROMPT_PRE'$(git branch &>/dev/null;\
if [ $? -eq 0 ]; then \
	echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
	if [ "$?" -eq "0" ]; then \
		echo "\[\033[38;5;28m\]"$(__git_ps1 " (%s)"); \
	else \
		echo "\[\033[38;5;124m\]"$(__git_ps1 " (%s)"); \
	fi) '$PROMPT_SUF'"; \
else \
# prompt when not in repo
	echo " '$PROMPT_SUF'"; \
fi)'

docker-clean-images()
{
    # If there are dangling docker images, remove them
	if [[ $(docker images -a --filter=dangling=true -q) ]];
    then
		tput setaf 3; docker rmi $(docker images -a --filter=dangling=true -q) ; tput setaf 9
    else
        printf "\033[0;31mThere are no dangling images.\n"
    fi
}

docker-clean-ps()
{
    # If there are stopped containers, remove them
	if [[ $(docker ps --filter=status=exited --filter=status=created -q) ]];
    then
		tput setaf 3; docker rm $(docker ps --filter=status=exited --filter=status=created -q) ; tput setaf 9
    else
        printf "\033[0;31mThere are no stopped containers.\n"
    fi
}

alias less='less -R'

alias ls='ls -CF --color=always'
alias ll='ls -lFa'
alias lll='ll | less'
alias lsl='ls | less'
alias la='ls -CFa'
alias lal='ls -CFa | less'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias fhere='find . -name '
alias df='df -Tha --total'
alias du='du -ach | sort -h'
alias dul='du | less'
alias free='free -mt'
alias ps='ps auxf'
alias psl='ps | less'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias mkdir='mkdir -pv'
alias histg='history | grep'
alias x='exit'
alias clr='clear'
alias tmx='tmux'
alias tmux='tmux -2 attach'
alias sudo='sudo '

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# enable git completion & prompt
source ~/.git-completion
source ~/.git-prompt

