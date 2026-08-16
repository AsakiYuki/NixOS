{inputs, ...} @ args: (import ./helpers/nixosConfigurations.nix args (let
  root = path: ./. + path;
in {
  ideapad-slim-5 = {
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-ideapad-slim-5
      inputs.lanzaboote.nixosModules.lanzaboote
      (root "/devices/ideapad-slim-5/configuration.nix")
    ];
  };
  home-server = {
    modules = [
      (root "/devices/home-server/configuration.nix")
    ];
  };
  wsl = {
    modules = [
      inputs.nixos-wsl.nixosModules.default
      (root "/devices/wsl/configuration.nix")
    ];
  };
}))
