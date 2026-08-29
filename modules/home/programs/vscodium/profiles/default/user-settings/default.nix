{...}: {
    imports = [
        ./vscord.nix
        ./catppuccin.nix
    ];

    programs.vscodium.profiles.default.userSettings = {
        "editor.fontSize" = 12;
        "editor.fontFamily" = "Tahoma, \"SauceCodePro Nerd Font\"";
        "terminal.integrated.fontFamily" = "\"SauceCodePro Nerd Font\"";
    };
}