{lib, ...}: {
  keyboardShortcuts =
    [
      {
        id = "key_selectLastTab";
        disabled = true;
      }
    ]
    ++ (builtins.genList (
        id: let
          workspace = id + 1;
        in {
          id = "zen-workspace-switch-${toString workspace}";
          key = toString (lib.mod workspace 10);
          modifiers.alt = true;
        }
      )
      10)
    ++ (builtins.genList (id: {
        id = "key_selectTab${toString (id + 1)}";
        disabled = true;
      })
      8);
}
