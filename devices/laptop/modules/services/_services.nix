{ inputs, pkgs }: {
    services = import ./_general.nix // {
        pipewire = import ./pipewire.nix;
    };
}