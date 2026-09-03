{
  unstable,
  pkgs,
  ...
}: {
  userSettings = {
    "nixEnvSelector.useFlakes" = true;

    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
    "nix.formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";
    "nix.serverSettings".nixd.formatting.command = ["${pkgs.alejandra}/bin/alejandra"];
  };

  extensions = with unstable.vscode-extensions; [
    arrterian.nix-env-selector
    bbenoist.nix
    jnoortheen.nix-ide
  ];
}
