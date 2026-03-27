{ pkgs, lib, config, ... }: {
    programs.steam = lib.mkIf config.services.steam {
        enable = true;
        extraCompatPackages = with pkgs; [
            proton-ge-bin
        ];
    };
}