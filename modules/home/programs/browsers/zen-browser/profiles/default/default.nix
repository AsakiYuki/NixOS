{
  pkgs,
  lib,
  ...
}: {
  programs.zen-browser.profiles.default = {...}: let
    spaces = [
      "3847d034-806b-4af9-b3a2-19f520b610a7"
      "7c395680-4832-428a-94d8-673684187477"
      "31958bc5-2e05-4b7a-a251-0b294e488fd4"
      "78af1b93-32ae-431d-9382-d8243c0b6083"
      "c6bc3ff7-ac6a-4790-80b1-19eb839284f5"
    ];
  in {
    imports = [
      ./keyboard-shortcuts.nix
      ./pins.nix
      ./sine.nix
      ./presets.nix
      ./search.nix
      ./settings.nix
      ./spaces.nix
    ];

    _module.args = {
      space-id = id: builtins.elemAt spaces id;
      inherit pkgs lib;
    };
  };
}
