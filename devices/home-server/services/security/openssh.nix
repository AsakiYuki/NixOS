{...}: {
  services.openssh = {
    enable = true;
    ports = [15523];
    settings = {
      X11Forwarding = true;
      PasswordAuthentication = false;
      AllowUsers = [
        "asakiyuki"
        "junko"
        "hieze"
        "forgejo"
      ];
    };
  };
}
