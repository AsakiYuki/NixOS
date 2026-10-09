{pkgs, ...}: {
  services.phpfpm.pools.wordpress = {
    user = "wordpress";
    group = "nginx";
    phpPackage = pkgs.php;
    settings = {
      "listen.owner" = "nginx";
      "listen.group" = "nginx";
      "listen.mode" = "0660";
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 4;
      "catch_workers_output" = "yes";
    };
    phpEnv = {
      PATH = "/run/current-system/sw/bin";
    };
  };

  users.users.wordpress = {
    isSystemUser = true;
    group = "nginx";
    extraGroups = ["nginx"];
  };

  systemd.tmpfiles.rules = [
    "d /var/www/wordpress 0775 wordpress nginx - -"
  ];
}
