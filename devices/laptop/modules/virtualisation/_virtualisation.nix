{ pkgs, ... }: {
    imports = [
        ./docker.nix
    ];

    virtualisation = {
        waydroid = {
            enable = true;
            package = pkgs.waydroid-nftables;
        };
        docker.enable = true;
    };
}