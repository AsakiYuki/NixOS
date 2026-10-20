{ config, lib, pkgs, ... }:
{
  programs.chromium.extensions = lib.mkIf config.programs.chromium.enable (
    with pkgs.chrome-extensions;
    [
      ublock-origin-lite
      tampermonkey
      keepassxc-browser
      proton-pass
      auto-tab-discard
      darkreader
      single-file
      sponsorblock-for-youtube-skip-sponsorships
      return-youtube-dislike
      auth-helper
      user-agent-string-switcher
      react-devtools
      vimium-c
      styl-us
      steam-database
      cookie-editor
      simple-translate
      onetab
      enhancer-for-youtube
    ]
  );
}
