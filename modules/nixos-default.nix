{
  lib,
  pkgs,
  ...
}: {
  config = {
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "Asia/Ho_Chi_Minh";
    system.stateVersion = lib.state-version;
    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
        trusted-users = ["@wheel"];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
    networking.hostName = lib.flake-name;
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";
      backupCommand = "${pkgs.trash-cli}/bin/trash";
    };
  };
}
