{
  lib,
  config,
  ...
}: (lib.mkUsers config {
  asakiyuki = {
    nix.is-trusted-user = true;

    root = {
      extraGroups = ["wheel"];
      hashedPasswordFile = config.age.secrets.asakiyukipwd.path;
    };

    home = {
      programs.btop.enable = true;
    };
  };
})
