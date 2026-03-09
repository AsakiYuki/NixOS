{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        wget
        git
        p7zip
        python3
        nodejs
        unzip
    ];
}