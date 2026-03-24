{ ... }: {
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

    initExtra = ''
        function git-commit() {
            git add .
            git commit -m "$1"
        }

        function git-push()  {
            git add .
            git commit -m "$1"
            git push origin HEAD
        }

        function git-pull() {
            git fetch origin HEAD
            git pull origin HEAD
        }

        function get-hash() {
            nix hash to-sri --type sha256 $(nix-prefetch-url --unpack "$1")
        }
    '';
}