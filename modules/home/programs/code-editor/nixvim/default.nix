{
  unstable-pkgs,
  osconfig ? {},
  config,
  lib,
  ...
}: {
  programs.nixvim = lib.mkIf (!config.programs.disable-module.neovim) {
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
