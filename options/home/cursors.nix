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
      type = lib.types.enum ([null] ++ (lib.attrNames cursors));
      default = null;
      description = "Cursor theme to use for the desktop";
    };
  };

  config.home.pointerCursor = lib.mkIf (cursors-theme != null) (let
    cursors-data = cursors.${cursors-theme};
    is-cursors-hash = (builtins.typeOf cursors-data) != "set";

    inherit
      (
        if is-cursors-hash
        then {
          stripRoot = true;
          hash = cursors-data;
          url = "https://static.asakiyuki.com/packages/cursors/linux/${cursors-theme}.tar.gz";
        }
        else {
          url = cursors-data.url or "https://static.asakiyuki.com/packages/cursors/linux/${cursors-theme}.tar.gz";
          hash = cursors-data.hash or (throw "${cursors-theme} is not a hash, please define in assets/cursors.json");
          stripRoot = cursors-data.strip-root or true;
        }
      )
      stripRoot
      url
      hash
      ;
  in {
    enable = true;
    name = cursors-name;
    size = 98;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
    sway.enable = true;
    dotIcons.enable = true;
    package = pkgs.runCommand "moveUp" {} ''
      mkdir -p $out/share/icons
      ln -s ${pkgs.fetchzip {
        inherit url hash stripRoot;
      }} $out/share/icons/${cursors-name}
    '';
  });
}
