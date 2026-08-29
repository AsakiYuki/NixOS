{unstable, ...}: {
    programs.vscodium.profiles.default.extensions = with unstable.vscode-extensions; [
        christian-kohler.path-intellisense
        
        catppuccin.catppuccin-vsc

        bbenoist.nix
        jnoortheen.nix-ide
        
        leonardssh.vscord

        wakatime.vscode-wakatime
    ];
}