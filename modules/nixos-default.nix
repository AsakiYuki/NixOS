{
  state-version,
  lib,
  name,
  pkgs,
  ...
}: {
  config = {
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "Asia/Ho_Chi_Minh";
    system.stateVersion = state-version;
    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "@wheel"
          "asakiyuki"
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
    networking.hostName = name;
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";
      backupCommand = "${pkgs.trash-cli}/bin/trash";
    };
  };
  options.device.flake-name = lib.mkOption {
    type = lib.types.str;
    default = name;
    description = "Flake name for quick rebuild";
  };
}
