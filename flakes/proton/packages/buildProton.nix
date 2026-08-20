{
  pname,
  args,
}: let
  proton = args.proton.${pname};
  releases = proton.releases;

  version-list =
    args.lib.mapAttrs' (name: value: {
      name = "${pname}-${name}";
      value = args.mkProtonPackage {
        inherit pname;
        version = name;
        src = value;
      };
    })
    releases;
in
  args.lib.mergeAttrs version-list {
    "${pname}-latest" = version-list."${pname}-${proton.latest}".overrideAttrs (prev: {
      preFixup = ''
        substituteInPlace "$out/compatibilitytool.vdf" \
          --replace-fail "${proton.source_name}" "${proton.override_name}"
      '';
    });
  }
