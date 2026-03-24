{ ... }: {
    programs = {
        firefox = {
            enable = true;
            profiles.default = {
                settings = {
                    "browser.startup.homepage" = "https://google.com";
                };
                userChrome = '''';
            };
        };
        
        chromium.enable = true;
    };   
}