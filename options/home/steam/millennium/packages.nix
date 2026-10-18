{ lib, ... }:
{
  options = {
    plugins = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      description = ''
        Millennium plugins to install. Each package must contain one plugin's
        files at its output root. Packages can be created with
        pkgs.millennium-plugin.
      '';
    };

    themes = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      description = ''
        Millennium themes to install. Each package must contain a theme's
        skin.json and assets at its output root. Packages can be created with
        pkgs.millennium-theme.
      '';
    };
  };
}
