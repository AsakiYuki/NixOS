{
  inputs,
  root,
  ...
} @ args: (import ../helpers/nixosConfigurations.nix args {
  ideapad-slim-5 = {
    description = "I love Denia <3";
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-ideapad-slim-5
      inputs.lanzaboote.nixosModules.lanzaboote
      (root "/devices/ideapad-slim-5/configuration.nix")
    ];
  };
  msi-sayu = {
    description = "Ngai Sayu ghec minh roi :(";
    modules = [
      (root "/devices/msi-sayu/configuration.nix")
    ];
  };
  home-server = {
    description = "My Home Lab, btw";
    modules = [
      (root "/devices/home-server/configuration.nix")
    ];
  };
  wsl = {
    description = "Windows Subsystem for Linux, what do you think?";
    modules = [
      inputs.nixos-wsl.nixosModules.default
      (root "/devices/wsl/configuration.nix")
    ];
  };
})
