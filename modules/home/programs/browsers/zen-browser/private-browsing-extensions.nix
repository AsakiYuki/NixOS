{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zen-browser = lib.mkIf (!config.programs.disable-module.zen-browser) {
    private-browsing-extension-packages = with pkgs.firefox-addons; [
      auth-helper
      proton-pass
      proton-vpn
      darkreader
      ublock-origin
      vimium-c
      user-agent-string-switcher
    ];
  };
}
