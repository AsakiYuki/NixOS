{ pkgs, ... }: {
    host-public-folder = import ./host_public_folder.nix { inherit pkgs; };
}