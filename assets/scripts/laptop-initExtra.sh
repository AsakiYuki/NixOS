function server-rebuild() {
    git-push "$1"
    ssh asakiyuki
    cd nixos
    sudo nixos-rebuild switch --flake /etc/nixos#server
    exit
}