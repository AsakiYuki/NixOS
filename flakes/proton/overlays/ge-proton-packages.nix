{
  mkProtonPackage,
  proton,
  lib,
  ...
}: let
  releases = proton.ge-proton.releases;
  pname = "ge-proton";
in
  lib.listToAttrs (map ({
    name,
    value,
  }: {
    name = "${pname}-${name}";
    value = mkProtonPackage {
      inherit pname;
      version = name;
      src = value;
    };
  }) (lib.attrsToList releases))
