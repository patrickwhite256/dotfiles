# change terraform based on what's in ~/lib/terraform

chtf() {
    if [ -z "$1" ]; then
        echo "Usage: chtf <version>"
        return 1
    fi
    if [ -e ~/lib/terraform/$1 ]; then
        rm -f ~/lib/terraform/terraform
        ln -s ~/lib/terraform/$1 ~/lib/terraform/terraform
    else
        echo -e "$red No terraform version \"$1\" found$rst"
        return 1
    fi
}

_chtf() {
    versions=()
    for v in $(ls ~/lib/terraform | egrep -v "terraform$"); do
        versions=($versions $v)
    done
    _values 'versions' $versions
}

compdef _chtf chtf
