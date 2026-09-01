{nixpkgs, ...}: shells: let
  inherit (nixpkgs) lib;

  knowSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
  allSystems = lib.unique (
    lib.concatLists (
      lib.mapAttrsToList (_: cfg: cfg.supportedSystems or knowSystems)
      shells
    )
  );

  forSystems = systems: f: lib.genAttrs systems (system: f system);
in {
  devShells = forSystems allSystems (system: let
    activeShells =
      lib.filterAttrs (
        _: cfg: lib.elem system (cfg.supportedSystems or knowSystems)
      )
      shells;
  in
    lib.mapAttrs (name: cfg: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = cfg.overlays or [];
        config.allowUnfree = true;
      };

      shellArgs =
        if lib.isFunction cfg.shell
        then cfg.shell {inherit pkgs lib system;}
        else cfg.shell;
    in
      pkgs.mkShell shellArgs)
    activeShells);
}
