{ ... }: let
    defaultBash = import ../../../../../global/programs/bash.nix {};
in {
    programs.bash =  {
        enable = true;
        shellAliases = defaultBash.shellAliases // {
            nrs = "sudo nixos-rebuild switch --flake /etc/nixos#wsl";
        };

        shellOptions = defaultBash.shellOptions;
        initExtra = defaultBash.initExtra;
    };
}