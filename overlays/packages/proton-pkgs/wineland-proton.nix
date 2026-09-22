{...} @ args: let
  pname = "wineland-proton";
in
  import ./buildProton.nix {
    inherit args pname;
  }
