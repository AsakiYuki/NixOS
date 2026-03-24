{ pkgs, ... }: {
    programs = {
        firefox = {
            enable = true;
            profiles.default = {
                settings = {
                    "browser.startup.homepage" = "about:home";
                };

                search = {
                    default = "google";
                    engines = {    
                        youtube = {
                            name = "YouTube";
                            definedAliases = [ "@yt" "@youtube" ];
                            urls = [
                                {
                                    template = "https://www.youtube.com/results";
                                    params = [
                                        { name = "search_query"; value = "{searchTerms}"; }
                                    ];
                                }
                            ];
                        };

                        nix-packages = {
                            name = "Nix Packages";
                            definedAliases = [ "@np" "@nixpkgs" ];
                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                            urls = [
                                {
                                    template = "https://search.nixos.org/packages";
                                    params = [
                                        { name = "type"; value = "packages"; }
                                        { name = "query"; value = "{searchTerms}"; }
                                    ];
                                }
                            ];
                        };

                        mynixos = {
                            name = "My NixOS";
                            definedAliases = [ "@mynixos" ];
                            urls = [
                                {
                                    template = "https://mynixos.com/search";
                                    params = [
                                        { name = "q"; value = "{searchTerms}"; }
                                    ];
                                }
                            ];
                        };

                        bing.metaData.hidden = true;
                        ddg.metaData.hidden = true;
                        perplexity.metaData.hidden = true;
                        wikipedia.metaData.hidden = true;
                    };
                };

                userChrome = builtins.readFile ../../../../../../assets/firefox/userChrome.css;
                userContent = builtins.readFile ../../../../../../assets/firefox/userContent.css;
            };
        };
        
        chromium.enable = true;
    };   
}