{ cursors ? "aemeath", size ? 48 }: let 
    _b = name: url: hash: { inherit name url hash; };

    cursors-data = ({
        castorice = _b
            "castorice"
            "https://static.asakiyuki.com/cursors/linux/castorice.tar.gz"
            "sha256-nqAC+Itr+TXLGG8zYDBoBve+MeRckds5BM23DrsCTMM=";
        
        aemeath = _b
            "aemeath"
            "https://static.asakiyuki.com/cursors/linux/aemeath.tar.gz"
            "sha256-0eEsUks5MwW4g5Xau24SgchX+LD9Ra3azAH0KL9JzQw=";
        
        elysia = _b
            "elysia"
            "https://static.asakiyuki.com/cursors/linux/elysia.tar.gz"
            "sha256-mjDHklWrX5Pp/vejRQiMk0VA6afY04HXGyGD0PcopdI=";

        cartethyia = _b
            "cartethyia"
            "https://static.asakiyuki.com/cursors/linux/cartethyia.tar.gz"
            "sha256-jYIDoX+rfUjw6LXrqE4y8j5IL0vByrrRkgRuz08Zy6U=";
    
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
