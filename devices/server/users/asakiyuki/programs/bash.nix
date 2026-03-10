{ ... }: let
    defaultBash = import ../../../../../global/programs/bash.nix {};
in {
    programs.bash =  {
        enable = true;
        shellOptions = defaultBash.shellOptions;
        shellAliases = defaultBash.shellAliases // {
            nrs = "sudo nixos-rebuild switch --flake /etc/nixos#server";
        };
        initExtra = ''
            ${defaultBash.initExtra}
        '';
    };
}