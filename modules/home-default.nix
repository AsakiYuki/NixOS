{
  lib,
  pkgs,
  state-version,
  flake-name,
  ...
}: {
  programs.home-manager.enable = true;

  home = {
    username = builtins.head (lib.splitString "@" flake-name);
    stateVersion = state-version;
  };

  home.activation.trashBackups = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${pkgs.trash-cli}/bin/trash $VERBOSE_ARG ~/.*.bak ~/.config/*/*.bak 2>/dev/null || true
  '';

  specialisation = {};
}
