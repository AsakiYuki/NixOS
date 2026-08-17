{...} @ args: let
  pname = "cachyos-proton";
in
  import ./buildProton.nix {
    inherit args pname;
  }
