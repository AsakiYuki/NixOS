{
  lib,
  pkgs,
  ...
}: {
  userSettings = {
    "editor.formatOnSave" = true;
    "files.autoSave" = "onFocusChange";
    "editor.minimap.enabled" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "explorer.compactFolders" = false;
    "window.confirmSaveUntitledWorkspace" = false;
    "terminal.integrated.suggest.enabled" = true;
    "workbench.secondarySideBar.defaultVisibility" = "hidden";
    "security.workspace.trust.untrustedFiles" = "open";
    "files.eol" = "\\n";
    "editor.tabCompletion" = "on";
    "window.menuBarVisibility" = "visible";
    "window.commandCenter" = false;
    "explorer.autoReveal" = true;
    "problems.autoReveal" = true;
    "editor.mouseMiddleClickAction" = "openLink";
    "editor.selectionClipboard" = false;
    "terminal.integrated.enableMultiLinePasteWarning" = "never";
    "extensions.autoUpdate" = "off";
    "extensions.autoCheckUpdates" = false;
    "settingsSync.keybindingsPerPlatform" = true;
    "workbench.settings.enableNaturalLanguageSearch" = false;
    "workbench.startupEditor" = "none";
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    "terminal.integrated.defaultProfile.osx" = "Bash (Nix)";
    "terminal.integrated.profiles.osx"."Bash (Nix)" = {
      path = "/Users/asakiyuki/.nix-profile/bin/bash";
      args = ["-l"];
    };
  };
}
