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
      programs.btop.enable = true;
    };
  };
})
