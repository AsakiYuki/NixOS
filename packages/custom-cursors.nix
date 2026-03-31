{ cursors ? "aemeath", size ? 48 }: let 
    cursors-data = ({
        castorice = {
            name = "castorice-cursors";
            url = "https://static.asakiyuki.com/nixos/castorice-cursors.tar.gz";
            hash = "sha256-nqAC+Itr+TXLGG8zYDBoBve+MeRckds5BM23DrsCTMM=";
        };
        aemeath = {
            name = "aemeath-cursors";
            url = "https://static.asakiyuki.com/nixos/aemeath-cursors.tar.gz";
            hash = "sha256-0eEsUks5MwW4g5Xau24SgchX+LD9Ra3azAH0KL9JzQw=";
        };
        elysia = {
            name = "elysia-cursors";
            url = "https://static.asakiyuki.com/nixos/elysia-cursors.tar.gz";
            hash = "sha256-mjDHklWrX5Pp/vejRQiMk0VA6afY04HXGyGD0PcopdI=";
        };
    }).${cursors};
in {
    cursors = { pkgs, ... }: {
        gtk.enable = true;
        x11.enable = true;
        name = cursors-data.name;
        size = size;
        package = pkgs.runCommand "moveUp" {} ''
                mkdir -p $out/share/icons
                ln -s ${pkgs.fetchzip { url = cursors-data.url; hash = cursors-data.hash; }} $out/share/icons/${cursors-data.name}
            '';
    };
}