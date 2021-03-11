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

# Aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Functions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# enable git completion
source ~/.git-completion

# enable git prompt
source ~/.git-prompt
