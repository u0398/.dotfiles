# u0398's dotfiles

A collection of dotfiles for a number of programs:

- Zsh Shell
- Bash Shell
- tmux Terminal Multiplexer
- nvim Text Editor

Both Bash and Zsh shell configurations include some degree of completion and git support.

## Installation

The dotfiles are intended to be used in a detached worktree:
```
git clone --bare https://github.com/u0398/.dotfiles $HOME/.dotfiles
cd ~/.dotfiles
git config core.bare false
git config core.worktree "$HOME"
git config --local status.showUntrackedFiles no
cd ~
rm -r ~/.bash* ~/.profile
git --git-dir=$HOME/.dotfiles/ checkout
git --git-dir=$HOME/.dotfiles/ submodule update --init --recursive --remote
git --git-dir=$HOME/.dotfiles/ remote set-url origin git@github.com:u0398/.dotfiles.git
```
fzf requires installation. The config files need no modification, so use `--bin` to only install the binary.
```
cd ~/.config/fzf
./install --bin
```
Finally, switch to zsh shell, and reconnect.
```
chsh -s /bin/zsh
```

#
Then use the`dotgit`and`dotlazy`(lazygit) to work with the repository.

## Recommended Packages

- zsh
- lazygit
- neovim (unstable)
- fzf
