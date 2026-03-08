{ ... }: {
    users.users = {
        asakiyuki = {
            isNormalUser = true;
            extraGroups = [ "wheel" "docker" ];
        };
    };
}