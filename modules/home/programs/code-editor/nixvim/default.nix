{
  unstable-pkgs,
  osconfig,
  config,
  ...
}: {
  programs.nixvim = {
    _module.args = {
      inherit unstable-pkgs osconfig;
      hmconfig = config;
    };

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
