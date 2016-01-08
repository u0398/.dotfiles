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

#PS1="\[\033[38;5;220m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;7m\]\H \[$(tput sgr0)\]\[\033[38;5;8m\]- \[$(tput sgr0)\]\[\033[38;5;244m\]\d \t - \[$(tput sgr0)\]\[\033[38;5;220m\]\$? \n\[$(tput sgr0)\]\[\033[38;5;7m\]\w \[$(tput sgr0)\]\[\033[38;5;220m\]\\$ \[$(tput sgr0)\]"

if [[ $EUID -ne 0 ]]; then
	PROMPT_PRE="\[\033[38;5;220m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;7m\]\H \[$(tput sgr0)\]\[\033[38;5;8m\]- \[$(tput sgr0)\]\[\033[38;5;244m\]\d \t - \[$(tput sgr0)\]\[\033[38;5;220m\]\$?"
else
	PROMPT_PRE="\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;7m\]\H \[$(tput sgr0)\]\[\033[38;5;8m\]- \[$(tput sgr0)\]\[\033[38;5;244m\]\d \t - \[$(tput sgr0)\]\[\033[38;5;220m\]\$?"
fi

PROMPT_SUF="\n\[$(tput sgr0)\]\[\033[38;5;7m\]\w \[$(tput sgr0)\]\[\033[38;5;220m\]\\$ \[$(tput sgr0)\]"

PS1=$PROMPT_PRE'$(git branch &>/dev/null;\
if [ $? -eq 0 ]; then \
	echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
	if [ "$?" -eq "0" ]; then \
		echo "\[\033[38;5;28m\]"$(__git_ps1 " (%s)"); \
	else \
		echo "\[\033[38;5;124m\]"$(__git_ps1 " (%s)"); \
	fi) '$PROMPT_SUF'"; \
else \
# @2 - Prompt when not in GIT repo
	echo " '$PROMPT_SUF'"; \
fi)'

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias lla='ll -A'
alias l='ls -CF'

alias x='exit'
alias clr='clear'
alias tmux='tmux -2 attach'
alias sudo='sudo '

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# enable git completion
source ~/.git-completion.bash

# enable git prompt
source ~/.git-prompt
