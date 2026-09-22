{...} @ args: let
  pname = "cachyos-proton-v3";
in
  import ./buildProton.nix {
    inherit args pname;
  }
