{
  lib,
  config,
  ...
}: {
  options.steam.protonPackages = lib.mkOption {
    type = with lib.types; [listOf package];
    default = [];
  };

  config = {};
}
