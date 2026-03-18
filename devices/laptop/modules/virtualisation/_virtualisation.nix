{ ... }: {
    imports = [
        ./docker.nix
    ];

    virtualisation = {
        waydroid.enable = true;
        docker.enable = true;
    };
}