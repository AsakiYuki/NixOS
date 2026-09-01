{
  nix-on-droid,
  nixpkgs,
  ...
}: {
  nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
    pkgs = import nixpkgs {system = "aarch64-linux";};

    modules = [../host/android];
  };
}
