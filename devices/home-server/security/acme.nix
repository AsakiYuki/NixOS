{...}: {
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "me@asakiyuki.com";
      server = "https://acme-v02.api.letsencrypt.org/directory";
    };
  };
}
