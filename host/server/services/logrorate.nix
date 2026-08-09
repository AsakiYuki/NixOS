{...}: {
  services.logrotate = {
    enable = true;
    checkConfig = true;
  };
}
