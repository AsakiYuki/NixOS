{lib, ...}: {
  options.steam.protonPackages = lib.mkOption {
    type = with lib.types; [listOf anything];
  };
}
