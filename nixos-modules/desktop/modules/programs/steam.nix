{ pkgs, lib, config, ... }: {
    programs.steam = lib.mkIf config.device.services.steam {
        enable = true;
        extraCompatPackages = with pkgs; [
            proton-ge-bin
        ];
    };
}