{ pkgs, ... }: {
    hardware = {
        enableRedistributableFirmware = true;
        firmware = [ pkgs.sof-firmware ];
    };
}