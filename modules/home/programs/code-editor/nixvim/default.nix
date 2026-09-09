{
  unstable-pkgs,
  osconfig,
  ...
}: {
  programs.nixvim = {
    _module.args = {inherit unstable-pkgs osconfig;};

    imports = [
      ./keymaps
      ./plugins
      ./lua

      ./extra-packages.nix
      ./colorschemes.nix
      ./settings.nix
    ];
  };
}
