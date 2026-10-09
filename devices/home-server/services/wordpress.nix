{ ... }: {
  services.wordpress.sites = {
    localhost = {
      virtualHost.listen = [
        {
          ip = "*";
          port = 3367;
        }
      ];
      settings = {
        AUTOMATIC_UPDATER_DISABLED = true;
      };
    };
  };
}
