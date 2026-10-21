{...}: {
  users.users = {
    asakiyuki.extraGroups = ["wheel" "public"];
    junko.extraGroups = ["public"];

    gitea-runner = {
      isSystemUser = true;
      group = "gitea-runner";
      extraGroups = ["docker"];
    };

    static = {
      group = "public";
      isSystemUser = true;
    };

    wordpress = {
      group = "wordpress";
      home = "/var/empty";
      isSystemUser = true;
    };

    forgejo = {
      group = "forgejo";
      isSystemUser = true;
      useDefaultShell = true;
      home = "/var/lib/forgejo";
      createHome = false;
    };
  };
}
