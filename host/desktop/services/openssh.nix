{...}: {
  services.openssh = {
    ports = [22];
    settings = {
      AllowUsers = [
        "asakiyuki"
      ];
    };
  };
}
