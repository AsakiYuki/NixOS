{
    shellAliases = {
        cls = "clear";
        cleanup = "sudo nix-collect-garbage -d";
        cls-log = "sudo journalctl --vacuum-time=1s";
    };

    shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
        "autocd"
    ];

    initExtra = builtins.readFile ../../assets/scripts/initextra.sh;
}