alias cd="venv_cd"
alias cd..="cd .."
alias ..="cd .."
alias less="less -F"
alias open="xdg-open"
alias clang++="clang++ -I/usr/local/include/c++/v1"
alias tmux="deactivate || : && tmux -2"

if [ -e ~/.bash_aliases.local ]; then
    source ~/.bash_aliases.local
fi
