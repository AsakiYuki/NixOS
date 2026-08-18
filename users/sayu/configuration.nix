{
  lib,
  config,
  ...
}: (lib.mkUsers config {
  sayu = {
    root = {
      extraGroups = ["wheel"];
    };

    home = {
      theme.cursors = "wuthering-waves/denia";
      programs.btop.enable = true;
    };
  };
})
