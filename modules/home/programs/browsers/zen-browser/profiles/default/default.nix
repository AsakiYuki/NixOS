{pkgs, ...}: {
  programs.zen-browser.profiles.default = {...}: {
    _module.args = {inherit pkgs;};
    sine = {
      enable = true;
    };
  };
}
