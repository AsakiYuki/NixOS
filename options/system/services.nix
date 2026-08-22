{lib, ...}: {
  options = {
    services.tailscale.disable-agenix-secrets = lib.mkEnableOption "tailscale agenix secrets";
  };
}
