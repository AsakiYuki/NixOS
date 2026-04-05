{ inputs, pkgs, ... }: {
    imports = [
        ./_general.nix
        ./pipewire.nix
    ];

    services = {
        xserver.videoDrivers = [
            "modesetting"
            "fbdev"
            "amdgpu"
        ];
    };
}
