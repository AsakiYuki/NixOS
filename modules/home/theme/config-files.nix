{
  lib,
  pkgs,
  osconfig,
  ...
}: {
  xdg.configFile."autostart/apply-catppuccin-theme.desktop" = let
    cfg = osconfig.device.theme.catppuccin;
    flavour = "${lib.toUpper (builtins.substring 0 1 cfg.flavour)}${builtins.substring 1 (-1) cfg.flavour}";
    accent = "${lib.toUpper (builtins.substring 0 1 cfg.accent)}${builtins.substring 1 (-1) cfg.accent}";

    kdePlasmaEnabled = lib.attrByPath ["device" "de" "kdePlasma" "enable"] false osconfig;
    script = pkgs.writeShellScript "apply-catppuccin-theme" ''
      if [ ! -f "$HOME/.config/.catppuccin_applied" ]; then
        ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme Catppuccin${flavour}${accent}
        touch "$HOME/.config/.catppuccin_applied"
      fi
    '';
  in
    lib.mkIf kdePlasmaEnabled {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Apply Catppuccin Theme
        Exec=${script}
        Hidden=false
        NoDisplay=true
        X-KDE-autostart-phase=1
      '';
    };
}
