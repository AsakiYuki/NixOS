{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (!config.programs.disable-module.dolphin) {
    programs.dolphin.settings = {
      General = {
        RememberOpenedTabs = false;
        ModifiedStartupSettings = true;
        FilterBar = true;
      };
      ContextMenu = {
        ShowOpenTerminal = false;
      };
    };
  };
}
