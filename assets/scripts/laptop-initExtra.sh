function server-rebuild() {
    git-push "$1"
    ssh asakiyuki
    cd nixos
    exit
}