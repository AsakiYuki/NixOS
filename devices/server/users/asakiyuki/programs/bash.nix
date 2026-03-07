{ ... }: let
    defaultBash = import ../../../../../global/programs/bash.nix {};
in {
    programs.bash =  {
        enable = true;
        shellAliases = defaultBash.shellAliases // {
            nrs = "sudo nixos-rebuild switch --flake /etc/nixos#server";
        };

        shellOptions = defaultBash.shellOptions;
    };
}