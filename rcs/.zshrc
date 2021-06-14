# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### configure plugins

SP_PROJECT_DIRS=(~/workspace:1 ~/workspaces:1)

### zgen config

ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc ${HOME}/.zshrc.local)

source $HOME/.zgen/zgen.zsh

if ! zgen saved; then
    zgen oh-my-zsh
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/golang
    zgen oh-my-zsh plugins/vi-mode
    zgen oh-my-zsh plugins/zsh-interactive-cd

    zgen load $HOME/workspace/dotfiles/zsh/web-search
    zgen load $HOME/workspace/dotfiles/zsh/dotfile-check
    zgen load $HOME/workspace/dotfiles/zsh/is
    zgen load $HOME/workspace/dotfiles/zsh/switch-project
    zgen load $HOME/workspace/dotfiles/zsh/change-terraform

    zgen load romkatv/powerlevel10k powerlevel10k

    zgen save
fi

### configure powerlevel10k

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### general config

bindkey -s '^p' 'vim +CtrlP\n'

if [[ -s $HOME/bin/vim ]]; then
    export EDITOR=$HOME/bin/vim
else
    export EDITOR=vim
fi

source ~/.zsh_aliases
if [ -e $HOME/.zshrc.local ]; then 
    source $HOME/.zshrc.local
fi

export GOPATH=$HOME/go
export PATH=$HOME/bin:/usr/local/bin:$PATH:$GOPATH/bin
