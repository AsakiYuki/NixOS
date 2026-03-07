{ ... }: {
    virtualisation = {
        docker = import ./docker.nix {};
    };
}