{ lib, ... }: {
    options.device.services = {
        steam = lib.mkDefaultEnable true;
    }
}