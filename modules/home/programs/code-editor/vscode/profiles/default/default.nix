{...}: {
  imports = [
    ../_lang/markdown

    ../_tools/discord
    ../_tools/git
    ../_tools/prettier
    ../_tools/remote
    ../_tools/themes
    ../_tools/keybinds

    ./usersettings
    ./extensions.nix
    ./keybindings.nix
  ];
}
