{ inputs, pkgs, ... }:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "bak";

    users.asakiyuki = {
      _module.args = { inherit inputs asa-lib pkgs; };

      imports = [
        ./users/asakiyuki/configuration.nix
      ];
    };
  };

  users.users = {
    asakiyuki = {
      isNormalUser = true;
      shell = pkgs.bash;
    };
  };
}
