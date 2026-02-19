# parse a JWT

parsetoken() {
    echo $1 | cut -d'.' -f1 | base64 -d | jq
    echo
    echo $1 | cut -d'.' -f2 | base64 -d | jq
    echo
}
