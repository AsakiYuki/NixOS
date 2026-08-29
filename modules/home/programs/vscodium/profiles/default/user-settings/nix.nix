{...}: {
    programs.vscodium.profiles.default.userSettings = {
      "nixEnvSelector.useFlakes" = true;
      
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.formatterPath" = "nixfmt";
      "nix.serverSettings".nixd.formatting.command = ["alejandra"];
    };
}
