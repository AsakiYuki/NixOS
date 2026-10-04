{
  lib,
  pkgs,
  config,
  is-home-configurations,
  osconfig ? {},
  ...
}: let
  cfg = config.programs;
in {
  programs.bash = {
    sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
      BASH_SILENCE_DEPRECATION_WARNING = "1";
    };

    bashrcExtra = lib.mkIf pkgs.stdenv.isDarwin ''
      export BASH_SILENCE_DEPRECATION_WARNING=1
    '';

    iris = {
      config = {
        core = {
          mode = "spec";
        };
      };
    };

    shellAliases = lib.attrsets.mergeAttrsList (
      let
        attOpt = condition: key: value: (lib.optionalAttrs condition {
          "${key}" = value;
        });
      in [
        rec {
          cls = "clear";
          cleanup = "sudo nix-collect-garbage -d";
          cls-log = "sudo journalctl --vacuum-time=1s";

          logout = "pkill -KILL -u $USER";

          nrs =
            if is-home-configurations
            then "home-manager switch --flake ${config.home.homeDirectory}/nixos#${lib.flake-name} -b backup --option warn-dirty false"
            else "sudo nixos-rebuild switch --flake /etc/nixos#${lib.flake-name} --option warn-dirty false";

          nrb =
            if is-home-configurations
            then "home-manager build --flake ${config.home.homeDirectory}/nixos#${lib.flake-name} --option warn-dirty false"
            else "sudo nixos-rebuild build --flake /etc/nixos#${lib.flake-name} --option warn-dirty false";

          system-update = toString (pkgs.writeShellScript "system-update" ''
            echo "Please wait for the system update process!";

            current_directory=$(pwd);

            cd /etc/nixos
            git pull origin main
            ${nrs}

            cd $current_directory

            echo "Update completed!"
          '');

          flake-upgrade = "nix flake update";

          slice-pdf = lib.mkIf cfg.qpdf.enable (toString (pkgs.writeShellScript "slice-pdf" "qpdf \"$1\" --pages . $3-$4 -- \"$2\""));

          get-hash = toString (pkgs.writeShellScript "get-hash" "nix hash convert --hash-algo sha256 --from nix32 $(nix-prefetch-url --unpack \"$1\")");
          get-process-env-vars = toString (pkgs.writeShellScript "get-process-env-vars" "xargs -0 -L1 -a /proc/$1/environ");
          nixos-list-generations = "sudo nix-env --list-generations -p /nix/var/nix/profiles/system";
          nixos-rollback = toString (pkgs.writeShellScript "nixos-rollback" ''
            sudo nix-env --switch-generation $1 -p /nix/var/nix/profiles/system
            sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
          '');
        }
        (attOpt config.programs.superfile.enable "spf" "superfile")
        (attOpt (lib.attrByPath ["virtualisation" "waydroid" "enable"] false osconfig) "wss" "waydroid session stop; exit;")
      ]
    );

    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
      "autocd"
    ];

    initExtra = lib.optionalString cfg.tmux.enable ''
      allowed_terms=("xterm-kitty" "xterm-ghostty")

      should_run_tmux=false
      for term in "''${allowed_terms[@]}"; do
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
