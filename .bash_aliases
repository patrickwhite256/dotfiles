alias cd="venv_cd"
alias cd..="cd .."
alias ..="cd .."
alias less="less -F"
alias open="xdg-open"
alias grep='grep -I --color=auto'
alias clang++="clang++ -I/usr/local/include/c++/v1"
alias tmux="deactivate || : && tmux -2"
alias ll="ls -la"
alias l="ls -a"
alias goroot="cd \$(git rev-parse --show-toplevel)"

if [ -e ~/.bash_aliases.local ]; then
    source ~/.bash_aliases.local
fi
