{ ... }: {
    programs.nixcord = {
        enable = true;
        discord = {
            enable = true;
            vencord.enable = true; 
        };

        config = {
            enableReactDevtools = true;
            themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha-blue.theme.css" ];

            plugins = {
                fakeNitro = {
                    enable = true;
                    enableEmojiBypass = false;
                };
            };
        };
    };
}