{ pkgs, fetchFromGitHub }: pkgs.stdenv.mkDerivation rec {
    pname = "lsfg-vk";
    version = "2.0.0-dev25";

    src = pkgs.fetchFromGitHub {
        owner = "PancakeTAS";
        repo = "lsfg-vk";
        tag = "v${version}";
        sha256 = "sha256-#####";
        fetchSubmodules = true;
    };

    dontBuild = true;

    meta = with pkgs.lib; {
        description = "A tool for recording and replaying Vulkan applications with low overhead.";
        homepage = "https://github.com/PancakeTAS/lsfg-vk/";
        license = with licenses; [ gpl3Only ];
    };
}