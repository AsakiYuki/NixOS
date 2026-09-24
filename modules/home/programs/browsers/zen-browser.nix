{lib, ...}: {
  programs.zen-browser = {
    icon = lib.root "/assets/programs/zen-browser/icon.png";
    profiles.default = {
      sine = {
        enable = true;
      };
    };
  };
}
