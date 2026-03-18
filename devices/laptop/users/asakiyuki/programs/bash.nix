{ ... }: let
    defaultBash = import ../../../../../common/programs/bash.nix {};
in {
    programs.bash =  {
        enable = true;
        shellAliases = defaultBash.shellAliases // {
            nrs = "sudo nixos-rebuild switch --flake /etc/nixos#laptop";
            flake-upgrade = "nix flake update";
        };

        shellOptions = defaultBash.shellOptions;
        initExtra = ''
            ${defaultBash.initExtra}

            allowed_terms=("xterm-kitty" "xterm-ghostty")

            should_run_tmux=false
            for term in "${"$" + "{allowed_terms[@]" + "}"}"; do
            if [[ "$TERM" == "$term" ]]; then
                should_run_tmux=true
                break
            fi
            done

            if [ -z "$TMUX" ] && [ "$should_run_tmux" = true ]; then
                exec tmux
            fi
        '';
    };
}