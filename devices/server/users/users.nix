{ pkgs, ... }: {
    users.users = {
        asakiyuki = {
            isNormalUser = true;
            shell = pkgs.bash;
            extraGroups = [ "wheel" "docker" ];
        };
        static = {
            isNormalUser = false;
        };
    };
}