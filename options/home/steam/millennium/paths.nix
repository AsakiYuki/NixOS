{ lib, ... }:
{
  options.paths = {
    plugins = lib.mkOption {
      type = lib.types.str;
      default = ".local/share/millennium/plugins";
      description = ''
        Plugin directory relative to the home directory. Millennium's Linux
        default is ~/.local/share/millennium/plugins.
      '';
    };

    themes = lib.mkOption {
      type = lib.types.str;
      default = ".steam/steam/steamui/skins";
      description = ''
        Theme directory relative to the home directory. Millennium's Linux
        default is ~/.steam/steam/steamui/skins.
      '';
    };

    config = lib.mkOption {
      type = lib.types.str;
      default = ".config/millennium";
      description = ''
        User configuration directory relative to the home directory.
      '';
    };
  };
}
