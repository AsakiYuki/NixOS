{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
      iris = inputs.iris.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (final: prev: {
        vendorHash = "sha256-q1szUQkhdKq2VhMuWYYWTahmDxGeVjvHLmjciZu3cBU=";
      });
    })
  ];
}
