{
  lib,
  config,
  pkgs,
  ...
}: let
  cursors = lib.importJSON (lib.root "/assets/cursors.json");
  cursors-theme = config.theme.cursors;
  cursors-name = lib.last (lib.splitString "/" cursors-theme);
in {
  options = {
    theme.cursors = lib.mkOption {
      type = lib.types.enum ([null] ++ (builtins.filter (name: !lib.hasPrefix "#" name) (lib.attrNames cursors)));
      default = null;
      description = "Cursor theme to use for the desktop";
    };
  };

  config.home.pointerCursor = lib.mkIf (cursors-theme != null) {
    enable = true;
    name = cursors-name;
    size = 98;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
    sway.enable = true;
    dotIcons.enable = true;
    package = let
      url = "https://static.asakiyuki.com/packages/cursors/linux/${cursors-theme}.tar.gz";
      hash = cursors.${cursors-theme};
      packages = pkgs.fetchzip {
        inherit url hash;
      };
    in (pkgs.runCommand "moveUp" {} ''
      mkdir -p $out/share/icons
      ln -s ${packages} $out/share/icons/${cursors-name}
    '');
  };
}
