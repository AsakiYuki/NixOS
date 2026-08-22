{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  age.secrets = let
    mkSecretIf = condition: file: extraOpts: (lib.mkIf condition ({file = lib.rootString file;} // extraOpts));
    cfgSvc = config.services;
    hasUser = user: builtins.hasAttr user config.users.users;
  in {
    # Service secrets
    cloudflare = mkSecretIf cfgSvc.cloudflare-dyndns.enable "/assets/secrets/services/cloudflare.secret.age" {};
    tailscale = mkSecretIf (cfgSvc.tailscale.enable && (!cfgSvc.tailscale.disable-agenix-secrets)) "/assets/secrets/services/tailscale.secret.age" {};
    nginxAuth = mkSecretIf cfgSvc.nginx.enable "/assets/secrets/services/nginx.auth.json.age" {};
    searxenv = mkSecretIf cfgSvc.searx.enable "/assets/secrets/services/searx.env.age" {};

    # User passwords
    asakiyukipwd = mkSecretIf (hasUser "asakiyuki") "/assets/secrets/users/asakiyuki.pwd.sha256.age" {};
  };

  environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default];
  programs.bash.interactiveShellInit = lib.readRootFile "/scripts/shell/completions/agenix.sh";
}
