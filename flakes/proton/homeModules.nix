{
  lib,
  config,
  ...
}: {
  options.programs.steam.protonPackages = lib.mkOption {
    type = with lib.types; listOf package;
    default = [];
  };

  config.home.file = builtins.listToAttrs (map (proton: let
      name = proton.pname;
      version = proton.version;
    in {
      name = ".local/share/Steam/compatibilitytools.d/${name}-${version}";
      value.source = proton;
    })
    config.programs.steam.protonPackages);
}
