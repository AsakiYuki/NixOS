{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Ho_Chi_Minh";

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.sayu = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    git
    vscode
    wget
  ];
}
