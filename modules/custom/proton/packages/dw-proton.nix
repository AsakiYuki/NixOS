{...} @ args: let
  pname = "dw-proton";
in
  import ./buildProton.nix {
    inherit args pname;
  }
