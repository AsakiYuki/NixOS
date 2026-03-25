function server-rebuild() {
    git-push "$1"
    ssh asakiyuki
    sudo nixos-rebuild switch --flake /etc/nixos#server
    exit
}