{ ... }: let
	defaultGit = import ../../../../../../common/programs/git.nix {};
in {
    programs.git = {
        enable = true;
        lfs.enable = true;
        settings = defaultGit.config;
    };
}