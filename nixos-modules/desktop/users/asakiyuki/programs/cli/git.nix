{ asa-lib, ... }: let
	defaultGit = import (asa-lib.root "/common/programs/git.nix") {};
in {
    programs.git = {
        enable = true;
        lfs.enable = true;
        settings = defaultGit.config;
    };
}