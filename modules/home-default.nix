{
  lib,
  state-version,
  flake-name,
  ...
}: {
  programs.home-manager.enable = true;
  home = {
    username = builtins.head (lib.splitString "@" flake-name);
    stateVersion = state-version;
  };
}
