{
  pname,
  args,
}: let
  releases = args.proton.${pname}.releases;
in
  args.lib.mapAttrs' (name: value: {
    name = "${pname}-${name}";
    value = args.mkProtonPackage {
      inherit pname;
      version = name;
      src = value;
    };
  })
  releases
