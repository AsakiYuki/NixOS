{unstable, ...}: {
    programs.vscodium.profiles.default.extensions = with unstable.vscode-extensions; [
        leonardssh.vscord
        wakatime.vscode-wakatime
    ];
}