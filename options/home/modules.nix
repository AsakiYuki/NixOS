{lib, ...}: {
  options.programs.disable-module = {
    vscode = lib.mkEnableOption "vscode";
    vscodium = lib.mkEnableOption "vscodium";
    firefox = lib.mkEnableOption "firefox";
    zen-browser = lib.mkEnableOption "zen-browser";
    dolphin = lib.mkEnableOption "dolphin";
    neovim = lib.mkEnableOption "neovim";
  };
}
