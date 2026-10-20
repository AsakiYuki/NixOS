{
  lib,
  config,
  ...
}:
lib.optionalAttrs (!config.programs.disable-module.zen-browser) {
  imports = [
    ./default
  ];
}
