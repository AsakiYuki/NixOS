{...} @ args: let
  pname = "wineland-proton-v3";
in
  import ./buildProton.nix {
    inherit args pname;
  }
