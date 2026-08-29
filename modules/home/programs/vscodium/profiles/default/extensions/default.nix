{unstable, ...}: {
    programs.vscodium.profiles.default.extensions = with unstable.vscode-extensions; [
        wakatime.vscode-wakatime
    ];
}