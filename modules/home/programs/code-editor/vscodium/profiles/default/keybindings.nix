{...}: {
  keybindings = [
    {
      key = "ctrl+shift+i";
      command = "explorer.newFile";
      when = "filesExplorerFocus";
    }
    {
      key = "ctrl+shift+n";
      command = "explorer.newFolder";
      when = "filesExplorerFocus";
    }
  ];
}
