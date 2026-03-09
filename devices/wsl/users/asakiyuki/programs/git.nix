{ ... }: let
	defaultGit = import ../../../../../global/programs/git.nix {};
in {
    programs.git = {
        enable = true;
        lfs.enable = true;
        extraConfig = defaultGit.config;
    };
}