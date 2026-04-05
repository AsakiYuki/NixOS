{ inputs, ... }:
{
  imports = [
    ./users/users.nix

    ./options/_options.nix

    ./modules/networking.nix
    ./modules/packages.nix

    ./modules/services/_services.nix
    ./modules/systemd/_systemd.nix
    ./modules/virtualisation/_virtualisation.nix
    ./modules/programs/_programs.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  time.timeZone = "Asia/Ho_Chi_Minh";
}

