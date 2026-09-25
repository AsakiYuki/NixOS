{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./profiles/default
    ./policies.nix
  ];

  programs.zen-browser = lib.mkIf (!pkgs.stdenv.isDarwin) {
    icon = lib.root "/assets/programs/zen-browser/icon.png";
  };
}
