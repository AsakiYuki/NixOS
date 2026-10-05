{lib, ...} @ args: let
  custom-pkgs-data = lib.importJSON ../../../assets/packages.json;
  custom-pkgs = import ./media // import ./games // import ./cli // import ./macos; 
in (lib.mapAttrs' (name: path: {
    inherit name;
    value = import path (args // {data = custom-pkgs-data;});
  })
  custom-pkgs)
