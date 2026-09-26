let
  fs = import ./helpers/fileSystem.nix;
  sshPubKey = file: fs.readRootFile "/assets/public/ssh/${file}";

  root = sshPubKey "root.key.pub";
  system = {
    home-server = sshPubKey "home-server/system.nixos.pub";
    ideapad-slim-5-14apk10 = sshPubKey "ideapad-slim-5-14apk10/system.nixos.pub";
    ideapad-slim-5-14apk10-wsl = sshPubKey "ideapad-slim-5-14apk10/system.nixos.wsl.pub";
  };

  systems = [system.home-server system.ideapad-slim-5-14apk10 system.ideapad-slim-5-14apk10-wsl];
in
  builtins.mapAttrs (_: value: value // {publicKeys = value.publicKeys ++ [root];}) {
    # Service secrets
    "assets/secrets/services/cloudflare.secret.age".publicKeys = [system.home-server];
    "assets/secrets/services/nginx.auth.json.age".publicKeys = [system.home-server];
    "assets/secrets/services/tailscale.secret.age".publicKeys = systems;

    # User passwords
    "assets/secrets/users/asakiyuki.pwd.sha256.age".publicKeys = systems;
  }
