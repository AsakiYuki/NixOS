{ pkgs, ... }: {
  extensionButtons = {
    nav-bar = map (addon: addon.meta.addonid) (
      with pkgs.firefox-addons;
      [
        enhancer-for-youtube
        auth-helper
        proton-pass
      ]
    );
  };

  extensions = { ... }: {
    packages = import ../../../shared/extensions.nix { inherit pkgs; };
  };
}
