{lib, sources, ...} @ args: let
  custom-pkgs-data = sources.packages.programs;
  custom-pkgs = import ./media // import ./games // import ./cli // import ./macos // import ./dev;
in (lib.mapAttrs' (name: path: {
    inherit name;
    value = import path (args // {data = custom-pkgs-data;});
  })
  custom-pkgs)
