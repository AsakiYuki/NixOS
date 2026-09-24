{lib, ...}: {
  imports = [
    ./profiles/default
    ./policies.nix
  ];

  programs.zen-browser = {
    icon = lib.root "/assets/programs/zen-browser/icon.png";
  };
}
