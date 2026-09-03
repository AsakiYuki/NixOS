{...}: {
  imports = [
    ../_lang/markdown

    ../_tools/git
    ../_tools/prettier
    ../_tools/remote
    ../_tools/themes

    ./usersettings
    ./extensions.nix
    ./keybindings.nix
  ];
}
