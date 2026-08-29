{...}: {
  programs.vscodium.profiles.default.userSettings = {
    "editor.formatOnSave" = true;
    "files.autoSave" = "onFocusChange";
    "vscord.app.name" = "VSCodium";
    "editor.minimap.enabled" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "explorer.compactFolders" = false;
    "window.confirmSaveUntitledWorkspace" = false;
    "window.newWindowProfile" = "default";
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
  };
}
