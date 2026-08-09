{...}: {
  home-manager = {
    useGlobalPkgs = true;
    users = {
      asakiyuki.imports = [./asakiyuki];
    };
  };

  users.users.asakiyuki.extraGroups = ["docker"];
}
