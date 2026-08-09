{
  pkgs,
  lib,
  # inputs,
  ...
}: {
  boot = {
    supportedFilesystems = ["ntfs"];
    # kernelPackages = pkgs.linuxPackagesFor inputs.chaotic.packages.${pkgs.stdenv.hostPlatform.system}.linux_cachyos;
    kernelPackages = pkgs.linuxPackages_cachyos;
    # extraModulePackages = [config.boot.kernelPackages.zenpower];

    kernelModules = ["ntsync"];

    kernelParams = [
      "amd_pstate=active"
      "nowatchdog"
      "modprobe.blacklist=sp5100_tco"
    ];

    loader = {
      systemd-boot.configurationLimit = 5;
      systemd-boot.enable = lib.mkForce false;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
