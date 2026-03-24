{ ... }: {
    programs = {
        firefox = {
            enable = true;
            profiles.default = {
                search = {

                };
                userChrome = {};
            };
        };
        
        chromium.enable = true;
    };   
}