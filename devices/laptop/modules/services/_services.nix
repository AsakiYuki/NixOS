{ inputs, pkgs, ... }: {
    imports = [
        ./_general.nix
    ];

    services = {
        pipewire = import ./pipewire.nix;
        xserver.videoDrivers = [
            "modesetting"
            "fbdev"
            "amdgpu"
        ];
    };
}