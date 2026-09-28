{pkgs, ...} @ args: let
in {
  extensionButtons = {
    nav-bar = [
      "authenticator@mymindstorm"
      "78272b6fa58f4a1abaac99321d503a20@proton.me"
    ];
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
    ];
  };
}
