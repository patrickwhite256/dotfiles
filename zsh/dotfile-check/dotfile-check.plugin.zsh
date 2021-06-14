# check dotfiles for updates every 8 hours 

if [ -e ~/.dotfile_check ]; then
    cur_date=$(date +%s)
    mod_date=$(date -r ~/.dotfile_check +%s)
    if (( $((cur_date - mod_date)) <= 28800 )); then
        return
    fi
fi
dotfiles_dir=$(dirname $(dirname $(readlink $HOME/.bashrc)))
local_head=$(cd $dotfiles_dir && git rev-parse HEAD)
remote_head=$(cd $dotfiles_dir && git ls-remote origin | head -n 1 | cut -f1)
if [[ "$local_head" != "$remote_head" ]]; then
    echo -ne "$byel"
    echo -n "Dotfiles are out of date! To upgrade: cd $dotfiles_dir && git pull"
    echo -e "$rst"
fi
touch ~/.dotfile_check
