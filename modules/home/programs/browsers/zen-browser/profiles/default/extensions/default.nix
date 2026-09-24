{pkgs, ...} @ args: {
  extensionButtons = {
    nav-bar = [
      "authenticator@mymindstorm"
      "78272b6fa58f4a1abaac99321d503a20@proton.me"
    ];
  };

  extensions = {...}: {
    _module.args = args;

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
  };
}
