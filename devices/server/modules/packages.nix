{ pkgs, ... }: let 
    bun-x64-linue-baseline = import ../../../packages/bun.nix { inherit pkgs; };
in {
    environment.systemPackages = with pkgs; [
        wget
        git
        p7zip
        python3
        nodejs
        unzip

        bun-x64-linue-baseline
    ];
}