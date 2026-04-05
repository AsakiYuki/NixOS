function server-rebuild() {
  git-push "$1"
  ssh -t asakiyuki "
  cd ~/nixos;
  git pull --rebase origin HEAD;
  sudo nixos-rebuild switch --flake /etc/nixos#server;
  exit;
  "
}

function server-cleanup() {
  ssh -t asakiyuki "
    sudo nix-collect-garbage -d;
    exit;
  "
}
