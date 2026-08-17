{
  lib,
  mkProtonPackage,
  proton,
  ...
}: let
  releases = proton.ge-proton.releases;
  pname = "ge-proton";
in
  lib.mapAttrs' (name: value: {
    name = "${pname}-${name}";
    value = mkProtonPackage {
      inherit pname;
      version = name;
      src = value;
    };
  })
  releases
