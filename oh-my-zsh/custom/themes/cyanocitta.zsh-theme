# Cyanocitta theme
# 
# Based on Michele Bologna's amazing theme
#
# This a theme for oh-my-zsh. Features a colored prompt with:
# * username@host: [jobs] [git] workdir %
# * hostname color is based on hostname characters. When using as root, the
# prompt shows only the hostname in red color.
# * [jobs], if applicable, counts the number of suspended jobs tty
# * [git], if applicable, represents the status of your git repo (more on that
# later)
# * '%' prompt will be green if last command return value is 0, yellow otherwise.
#
# git prompt is inspired by official git contrib prompt:
# https://github.com/git/git/tree/master/contrib/completion/git-prompt.sh
# and it adds:
# * the current branch
# * '%' if there are untracked files
# * '$' if there are stashed changes
# * '*' if there are modified files
# * '+' if there are added files
# * '<' if local repo is behind remote repo
# * '>' if local repo is ahead remote repo
# * '=' if local repo is equal to remote repo (in sync)
# * '<>' if local repo is diverged


# colors
local c_user="${FG[081]}"
local c_su="${FG[009]}"
local c_at="${FG[015]}"
local c_host="${FG[007]}"
local c_dir="${FG[081]}"
local c_jobs="${FG[081]}"
local c_return="${FG[081]}"
local c_return_error="${FG[009]}"


local c_reset="%{$reset_color%}"


local green="%{$fg_bold[green]%}"
local red="%{$fg_bold[red]%}"
local cyan="%{$fg_bold[cyan]%}"
local yellow="%{$fg_bold[yellow]%}"
local blue="%{$fg_bold[blue]%}"
local magenta="%{$fg_bold[magenta]%}"
local white="%{$fg_bold[white]%}"
local reset="%{$reset_color%}"

local -a c_hostname
#c_hostname=%(!.$c_su.$c_user)

local username_command="%n"
local hostname_command="%m"
local dir="%~"

local username_output="%(!..$c_user$username_command$c_at@$c_reset)"
local hostname_output="$c_host$hostname_command$reset"
local dir_output="$c_dir$dir$c_reset"
local jobs_bg="$c_jobs: %j$c_reset"
#local return="%(?.%(!.$red.$green).$yellow)"
#local return="%(?.%(!.$c_return_error.$c_return).$c_return_error)%?"
local return=$?

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="$blue%%"
ZSH_THEME_GIT_PROMPT_MODIFIED="$red*"
ZSH_THEME_GIT_PROMPT_ADDED="$green+"
ZSH_THEME_GIT_PROMPT_STASHED="$blue$"
ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE="$green="
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=">"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="<"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="$red<>"

PROMPT='$username_output$hostname_output %1(j. [$jobs_bg].) - $return'
GIT_PROMPT='$(out=$(git_prompt_info)$(git_prompt_status)$(git_remote_status);if [[ -n $out ]]; then printf %s " $white($green$out$white)$reset";fi)'
PROMPT+="$GIT_PROMPT"
PROMPT+="
$current_dir_output %#$c_reset "

RPROMPT=''
