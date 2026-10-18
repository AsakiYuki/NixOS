{
  lib,
  config,
  osconfig,
  ...
}: let
  cfg = config.programs.steam.millennium;
  millenniumEnabled = lib.attrByPath ["programs" "steam" "millennium" "enable"] false osconfig;
in {
  options.programs.steam.millennium.plugins = lib.mkOption {
    type = with lib.types; listOf package;
    default = [];
    description = ''
      Millennium plugins to install. Each package must contain one plugin's
      files at its output root. Packages can be created with
      pkgs.millenniumPlugin.
    '';
  };

  config.home.file = lib.mkIf millenniumEnabled (builtins.listToAttrs (map (plugin: {
      name = ".local/share/millennium/plugins/${plugin.pname}";
      value.source = plugin;
    })
    cfg.plugins));
}
