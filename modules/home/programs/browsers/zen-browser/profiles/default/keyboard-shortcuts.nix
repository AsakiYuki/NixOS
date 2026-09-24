{lib, ...}: {
  keyboardShortcuts =
    builtins.genList (
      id: let
        workspace = id + 1;
      in {
        id = "zen-workspace-switch-${toString workspace}";
        key = toString (lib.mod workspace 10);
        modifiers.alt = true;
      }
    )
    10;
}
