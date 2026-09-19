{
  osconfig ? {},
  config,
  lib,
  ...
} @ args: {
  wayland.windowManager.hyprland = {
    extraConfig = ''
      -- Global Variables
      TouchpadName = nil

      -- Local Variables
      ${
        let
          cfg = config.programs;
        in
          if (cfg.ghostty.enable)
          then "local terminal = \"ghostty\""
          else if (cfg.kitty.enable)
          then "local terminal = \"kitty\""
          else ""
      }
      local homeDir = "${config.home.homeDirectory}"
      local fileManager = "dolphin"

      -- SOME DUMB SHIT UTILS FOR LUA
      ${builtins.readFile ./utils.lua}

       -- OS EXTRA CONFIGS
      ${lib.attrByPath ["device" "wm" "hyprland" "extraConfig"] "" osconfig}

      -- GENERAL HYPRLAND CONFIGURATIONS
      ${builtins.readFile ./hyprland.lua}

      -- KEYBIND
      ${import ./bind args}

      -- WINDOW RULES
      ${builtins.readFile ./window-rules.lua}

      -- WORKSPACES RULES
      ${builtins.readFile ./workspace-rules.lua}

      -- EVENTS
      ${builtins.readFile ./events.lua}

      -- AUTOSTART
      hl.on("hyprland.start", function ()
        ${builtins.readFile ./autostart.lua}
        ${lib.optionalString osconfig.programs.quickshell.enable ''hl.exec_cmd("setpriv --ambient-caps -all quickshell")''}
      end)

      -- INPUTS
      ${builtins.readFile ./inputs.lua}

      -- THEME
      ${builtins.readFile ./theme.lua}
    '';
  };
}
