{
  lib,
  config,
  ...
}: let
  sanitize = lib.mapAttrsRecursive (
    path: value:
      if lib.isList value
      then lib.concatStringsSep "," value
      else value
  );
in {
  config = lib.mkIf config.programs.dolphin.enable {
    home.packages = [
      config.programs.dolphin.package
    ];

    home.file = lib.mergeAttrsList [
      {
        # generate dolphinrc file
        ".config/dolphinrc" = {
          text = lib.generators.toINI {} (sanitize config.programs.dolphin.settings);
          force = true;
        };
      }

      (lib.mapAttrs' (name: value: {
          name = ".local/share/kio/servicemenus/${name}.desktop";
          value.text = lib.generators.toINI {} value;
        })
        config.programs.dolphin.services-menu)
    ];
  };
}
