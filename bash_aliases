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


