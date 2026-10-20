{
  inputs,
  root,
  ...
} @ args: (import ../helpers/homeConfigurations.nix args {
  "asakiyuki@Macbook-Air-M5" = {
    description = "apple";
    pkgs = inputs.nixpkgs.legacyPackages."aarch64-darwin";
    modules = [
      (root "/host/macos")
    ];
  };
})
