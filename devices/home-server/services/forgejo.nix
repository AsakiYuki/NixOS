{
  config,
  osconfig,
  pkgs,
  lib,
  ...
}: let
  cfg = osconfig.device.theme.catppuccin;

  catppuccin = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
    sha256 = "sha256-rZHLORwLUfIFcB6K9yhrzr+UwdPNQVSadsw6rg8Q7gs=";
    stripRoot = false;
  };
in {
  services.forgejo = {
    enable = true;
    database.type = "mysql";

    settings = {
      DEFAULT = {
        APP_NAME = "Asa's git";
      };

      cors = {
        ENABLED = true;
        ALLOW_DOMAIN = "https://*.asakiyuki.com";
        METHODS = "GET ,HEAD ,POST ,PUT ,PATCH ,DELETE ,OPTIONS";
        MAX_AGE = 86400;
      };

      ui = {
        THEMES = "catppuccin-${cfg.flavor}-${cfg.accent}";
        DEFAULT_THEME = "catppuccin-${cfg.flavor}-${cfg.accent}";
      };

      "ui.meta" = {
        AUTHOR = "Asaki Yuki";
        DESCRIPTION = "Asaki Yuki's git forge";
        KEYWORDS = "git ,forge ,asakiyuki";
      };

      service = {
        DISABLE_REGISTRATION = true;
      };

      actions = {
        ENABLED = false;
      };

      server = {
        HTTP_PORT = 21350;
        SSH_PORT = 15523;
        START_SSH_SERVER = false;
        SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
        SSH_DOMAIN = "asakiyuki.com";
        ROOT_URL = "https://git.asakiyuki.com/";
      };

      repository = {
        DISABLE_HTTP_GIT = true;
      };
    };
  };

  # services.gitea-actions-runner.instances.asa = lib.mkIf cfg.enable {
  #   enable = true;
  #   name = "Asa runner";
  #   url = cfg.settings.server.ROOT_URL;
  #   tokenFile = "/var/lib/gitea-runner/asa/token";

  #   labels = [
  #     "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-22.04"
  #     "ubuntu-22.04:docker://ghcr.io/catthehacker/ubuntu:act-22.04"
  #     "ubuntu-20.04:docker://ghcr.io/catthehacker/ubuntu:act-20.04"
  #     "self-hosted:docker://ghcr.io/catthehacker/ubuntu:act-22.04"
  #   ];

  #   settings = {
  #     container.network = "host";
  #   };

  #   hostPackages = [];
  # };

  systemd.tmpfiles.rules = lib.mkIf cfg.enable [
    "d ${cfg.customDir}/public/assets/css 0755 forgejo forgejo -"
  ];

  system.activationScripts.forgejoTheme = lib.mkIf config.services.forgejo.enable {
    text = ''
      mkdir -p ${config.services.forgejo.customDir}/public/assets/css
      mkdir -p ${config.services.forgejo.customDir}/public/assets/img

      cp -r ${catppuccin}/* ${config.services.forgejo.customDir}/public/assets/css/

      cp ${lib.root "/assets/programs/forgejo/img/logo.png"} ${config.services.forgejo.customDir}/public/assets/img/logo.png
      cp ${lib.root "/assets/programs/forgejo/img/favicon.png"} ${config.services.forgejo.customDir}/public/assets/img/logo.png
      cp ${lib.root "/assets/programs/forgejo/img/logo.svg"} ${config.services.forgejo.customDir}/public/assets/img/logo.svg
      cp ${lib.root "/assets/programs/forgejo/img/favicon.svg"} ${config.services.forgejo.customDir}/public/assets/img/logo.svg
    '';
  };
}
