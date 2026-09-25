{
  lib,
  pkgs,
  config,
  is-home-configurations,
  osconfig ? {},
  ...
}: {
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
        {
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
          flake-upgrade = "nix flake update";
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

    initExtra = let
      strOpt = condition: filePath: (lib.optionalString condition (lib.readRootFile filePath));
      cfg = config.programs;
    in ''
      ${lib.readRootFile "/scripts/shell/bash.sh"}
      ${strOpt cfg.qpdf.enable "/scripts/shell/qpdf.sh"}
      ${strOpt cfg.tmux.enable "/scripts/shell/tmux.sh"}
    '';
  };
}
