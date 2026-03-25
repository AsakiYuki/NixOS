function server-rebuild() {
    git-push "$1"
    ssh asakiyuki "
        cd ~/nixos;
        git pull --rebase origin HEAD;
        sudo nixos-rebuild switch --flake /etc/nixos#server;
        exit;
    "
}