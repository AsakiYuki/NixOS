{lib, ...}: {
  options.programs.zen-browser = {
    private-browsing-extension-packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };
  };
  config = {};
}
