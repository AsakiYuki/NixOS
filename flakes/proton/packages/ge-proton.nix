{...} @ args: let
  pname = "ge-proton";
in
  import ./buildProton.nix {
    inherit args pname;
  }
