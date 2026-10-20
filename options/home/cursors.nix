{
  lib,
  config,
  pkgs,
  ...
}: let
  cursors = lib.source-data.cursors;
  cursors-theme = config.theme.cursors;
  cursors-theme-path = lib.splitString "/" cursors-theme;
  cursors-category = builtins.elemAt cursors-theme-path 0;
  cursors-name = builtins.elemAt cursors-theme-path 1;
  cursor-options = lib.concatMap (
    category: map (name: "${category}/${name}") (lib.attrNames cursors.${category})
  ) (lib.attrNames cursors);
in {
  options = {
    theme.cursors = lib.mkOption {
      type = lib.types.enum ([null] ++ cursor-options);
      default = null;
      description = "Cursor theme to use for the desktop";
    };
  };

  config.home.pointerCursor = lib.mkIf (cursors-theme != null) (let
    cursors-data = cursors.${cursors-category}.${cursors-name};
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
          hash = cursors-data.hash or (throw "${cursors-theme} is not a hash, please define in assets/sources.json");
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
