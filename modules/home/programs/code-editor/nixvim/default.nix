{
  unstable,
  osconfig,
  ...
}: {
  programs.nixvim = {
    _module.args = {inherit unstable osconfig;};

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
