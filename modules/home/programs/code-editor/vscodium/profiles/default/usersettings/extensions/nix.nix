{pkgs, ...}: {
  userSettings = {
    "nixEnvSelector.useFlakes" = true;

    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
    "nix.formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";
    "nix.serverSettings".nixd.formatting.command = ["${pkgs.alejandra}/bin/alejandra"];
  };
}
