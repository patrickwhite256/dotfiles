alias cd="venv_cd"
alias cd..="cd .."
alias ..="cd .."
alias less="less -F"
alias open="xdg-open"
alias grep='grep -I --color=auto'
alias clang++="clang++ -I/usr/local/include/c++/v1"
alias tmux="deactivate || : && tmux -2"
alias ls="ls -h --color=auto"
alias ll="ls -la"
alias l="ls -l"
alias goroot="cd \$(git rev-parse --show-toplevel)"
# needed to work with custom vim install
alias vi="vim"
alias ag="ag --color-match='1;31'"
alias agg="ag -g"
alias aggu="ag -u -g"
alias grom="git fetch && git rebase origin/master"

if [ -e ~/.bash_aliases.local ]; then
    source ~/.bash_aliases.local
fi
