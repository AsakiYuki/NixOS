{ lib, ... }: {
    options.device.services = {
        steam = lib.mkEnableOption "steam";
    };
}