{pkgs, ...} @ args: let
in {
  extensionButtons = {
    nav-bar = map (addon: addon.meta.addonid) (with pkgs.firefox-addons; [
      enhancer-for-youtube
      auth-helper
      proton-pass
    ]);
  };

  extensions = {...}: {
    _module.args = args;

    packages = with pkgs.firefox-addons; [
      enhancer-for-youtube
      ublock-origin
      auth-helper
      cookie-editor
      darkreader
      sponsorblock
      header-editor
      proton-pass
      proton-vpn
      react-devtools
      return-youtube-dislikes
      tampermonkey
      user-agent-string-switcher
      vimium-c
      md-this-page
      cambridge-dictionary-english
      cookies-txt
      default-bookmark-folder
      google-sponsored-remover
      librezam
      simple-modify-header
      socialfocus
      styl-us
    ];
  };
}
