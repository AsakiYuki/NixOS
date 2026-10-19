{ ... }: {
  imports = [
    ./dolphin
    ./kde
    ./bash.nix
    ./cider-mv-resolver.nix
    ./options.nix
    ./vscode.nix
    ./zen-browser.nix
    ./steam.nix
  ];
}
