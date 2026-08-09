{...}: {
  home-manager.users = {
    asakiyuki.imports = [
      ./asakiyuki.nix
    ];
  };
}
