{
  lib,
  inputs,
  ...
}: {
  imports = [
    ./programs
    ./virtualisation.nix
    ./device.nix
    ./services
    ./nixpkgs
    ./home

    (lib.root "/modules/fonts.nix")
    (lib.root "/users/asakiyuki/configuration.nix")
  ];
  i18n.inputMethod.enable = true;
  boot.kernelParams = ["usbcore.autosuspend=-1"];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  xdg.menus.enable = true;
  services.dbus.enable = true;
}
