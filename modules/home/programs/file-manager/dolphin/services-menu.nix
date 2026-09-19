{
  pkgs,
  config,
  osconfig ? {},
  ...
}: {
  programs.dolphin = {...}: {
    _module.args = {
      inherit osconfig pkgs;
      hmconfig = config;
    };

    imports = [
      ./services-menu
    ];
  };
}
