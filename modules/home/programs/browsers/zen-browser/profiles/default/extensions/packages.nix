{pkgs, ...}: {
  packages = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
    auth-helper
    cookie-editor
    darkreader
    enhancer-for-youtube
    sponsorblock
    header-editor
    proton-pass
    proton-vpn
    react-devtools
    return-youtube-dislikes
    tampermonkey
    user-agent-string-switcher
    vimium-c
  ];
}
