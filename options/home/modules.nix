{lib, ...}: {
  options.programs.disable-module = {
    vscode = lib.mkEnableOption "vscode";
    vscodium = lib.mkEnableOption "vscodium";
    antigravity = lib.mkEnableOption "antigravity";
    firefox = lib.mkEnableOption "firefox";
    zen-browser = lib.mkEnableOption "zen-browser";
    dolphin = lib.mkEnableOption "dolphin";
    neovim = lib.mkEnableOption "neovim";
    steam = lib.mkEnableOption "steam";
    discord = lib.mkEnableOption "discord";
    hyprland = lib.mkEnableOption "hyprland";
    ghostty = lib.mkEnableOption "ghostty";
    kitty = lib.mkEnableOption "kitty";
  };
}
