{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
      iris = inputs.iris.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (final: prev: {
        vendorHash = "sha256-huyTWK6ef42KY2zmFIQuFoeR8B8XKHE7OVfFnfefeCU=";
      });
    })
  ];
}
