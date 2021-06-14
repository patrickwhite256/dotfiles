# switch projects with sp

if [ -z "$SP_PROJECT_DIRS" ]; then
    SP_PROJECT_DIRS=($GOPATH/src:3 ~/workspace:1 ~/workspaces:1)
fi

sp() {
    projects=""
    for dirdepth in ${SP_PROJECT_DIRS[@]}; do
        dir=$(echo $dirdepth | cut -d':' -f1)
        depth=$(echo $dirdepth | cut -d':' -f2)
        projects=$(echo -e "$projects\n$(find $dir -maxdepth $depth -mindepth $depth \( -type d -or -type l \))")
    done
    if [ -n "$1" ];then
        projects=$(echo "$projects" | grep $1)
    fi
    if [[ $(echo "$projects" | wc -l ) -eq 1 ]]; then
        cd $projects
    else
        cd $(echo "$projects" | pick)
    fi
}

_sp() {
    _arguments '1:project name:->pname'
    case "$state" in
        pname)
            projects=()
            for dirdepth in ${SP_PROJECT_DIRS[@]}; do
                dir=$(echo $dirdepth | cut -d':' -f1)
                depth=$(echo $dirdepth | cut -d':' -f2)
                for p in $(cd $dir && find . -maxdepth $depth -mindepth $depth \( -type d -or -type l \) | cut -d'/' -f2- ); do
                    projects=($projects $p)
                done
            done
            _values 'projects' $projects
    esac
}

compdef _sp sp
