{ ... }: {
    programs = {
        firefox = {
            enable = true;
            profiles.default = {
                settings = {
                    "browser.startup.homepage" = "https://google.com";
                };
                
                userChrome = builtins.readFile ../../../../../../assets/firefox/userChrome.css;
                userContent = builtins.readFile ../../../../../../assets/firefox/userContent.css;
            };
        };
        
        chromium.enable = true;
    };   
}