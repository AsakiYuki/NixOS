{pkgs}: {
  pname,
  version,
  meta,
  fetchurl,
  addonid,
  ...
}: (pkgs.stdenv.mkDerivation {
  inherit meta;

  name = "${pname}-${version}";
  src = pkgs.fetchurl fetchurl;

  preferLocalBuild = true;
  allowSubstitutes = false;

  buildCommand = ''
    dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
    mkdir -p "$dst"
    install -v -m644 "$src" "$dst/${addonid}.xpi"
  '';
})
