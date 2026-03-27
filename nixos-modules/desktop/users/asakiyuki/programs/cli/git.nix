{ libs, ... }: let
	defaultGit = import (libs.root "/common/programs/git.nix") {};
in {
    programs.git = {
        enable = true;
        lfs.enable = true;
        settings = defaultGit.config;
    };
}