{ pkgs, ... }:
{
  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.sof-firmware ];

    bluetooth = {
      enable = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
  };
}

