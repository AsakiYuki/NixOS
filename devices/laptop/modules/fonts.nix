{ pkgs, ... }: let
fetch-fonts = {
    segoe-ui = {
        light = pkgs.fetchurl {
            url = "https://c.s-microsoft.com/static/fonts/segoe-ui/west-european/light/latest.ttf";
            sha256 = "1bqbvpxqflh4an5ciawrkl0bxy58vqhxiynspcvpx1zyryxcjlhm";
        };

        semilight = pkgs.fetchurl {
            url = "https://c.s-microsoft.com/static/fonts/segoe-ui/west-european/semilight/latest.ttf";
            sha256 = "1y6rfxdwwfq1bgk7fj4bvhck1di6whw5h0yby8gj7x6y1cv4ka1p";
        };

        normal = pkgs.fetchurl {
            url = "https://c.s-microsoft.com/static/fonts/segoe-ui/west-european/normal/latest.ttf";
            sha256 = "0ac4hgmlxl6cgak7g39rvfk25gs3fm5wlnmc7mbpv38i7mkppiaf";
        };

        bold = pkgs.fetchurl {
            url = "https://c.s-microsoft.com/static/fonts/segoe-ui/west-european/bold/latest.ttf";
            sha256 = "147mk64y2hihy6s29dlgimcrfi7ihi68qjcrfdzqk6cvk8kr3f0q";
        };

        semibold = pkgs.fetchurl {
            url = "https://c.s-microsoft.com/static/fonts/segoe-ui/west-european/semibold/latest.ttf";
            sha256 = "0whxgk9q4j9pd3k462m0dyr39q7vk2lxla5whcckyfrks983c4nj";
        };
    };
};

custom = {
    tahoma = pkgs.stdenv.mkDerivation {
        pname = "tahoma";
        version = "1.0";
        dontUnpack = true;

        src = pkgs.fetchurl {
            url = "https://www.asakiyuki.com/static/fonts/Tahoma.ttf";
            sha256 = "129l1cprplci2xmxi0gnsjrvprr48xqp8kr5s9lrwcnaxvb4z4ni";
        };

        installPhase = ''
            mkdir -p $out/share/fonts/truetype
            cp $src $out/share/fonts/truetype/
        '';
    };

    segoe-ui = pkgs.stdenv.mkDerivation {
        pname = "segoe-ui";
        version = "1.0";
        dontUnpack = true;

        installPhase = ''
            mkdir -p $out/share/fonts/truetype

            cp ${fetch-fonts.segoe-ui.light} $out/share/fonts/truetype
            cp ${fetch-fonts.segoe-ui.semilight} $out/share/fonts/truetype
            cp ${fetch-fonts.segoe-ui.normal} $out/share/fonts/truetype
            cp ${fetch-fonts.segoe-ui.bold} $out/share/fonts/truetype
            cp ${fetch-fonts.segoe-ui.semibold} $out/share/fonts/truetype
        '';
    };
};
in {
    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
        custom.tahoma
        custom.segoe-ui
        
        # Nerd fonts
        nerd-fonts.sauce-code-pro
    ];
}