{ ... }: let
    defaultBash = import ../../../../../common/programs/bash.nix {};
in {
    programs.bash =  {
        enable = true;
        shellAliases = defaultBash.shellAliases // {
            nrs = "sudo nixos-rebuild switch --flake /etc/nixos#laptop";
        };

        shellOptions = defaultBash.shellOptions;
        initExtra = defaultBash.initExtra;
    };
}