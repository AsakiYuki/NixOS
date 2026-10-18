{ lib, ... }:
{
  options.programs.steam.millennium = lib.mkOption {
    default = { };
    type = lib.types.submodule {
      imports = [
        ./paths.nix
        ./packages.nix
        ./config.nix
        ./css.nix
      ];
    };
    description = "Millennium configuration and content for Steam.";
  };
}
