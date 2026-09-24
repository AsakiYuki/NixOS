{lib, ...}: {
  imports = [./profiles/default];

  programs.zen-browser = {
    icon = lib.root "/assets/programs/zen-browser/icon.png";
  };
}
