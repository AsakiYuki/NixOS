{ pkgs, asa-lib, ... }: {
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
                            icon = "https://www.youtube.com/s/desktop/83c08b77/img/favicon.ico";
                            urls = [
                                {
                                    template = "https://www.youtube.com/results";
                                    params = [
                                        { name = "search_query"; value = "{searchTerms}"; }
                                    ];
                                }
                            ];
                        };

                        google = {
                            name = "Google";
                            definedAliases = [ "@g" "@google" ];
                            icon = "https://www.gstatic.com/images/branding/searchlogo/ico/favicon.ico";
                            urls = [
                                {
                                    template = "https://www.google.com/search";
                                    params = [
                                        { name = "q"; value = "{searchTerms}"; }
                                    ];
                                }
                                {
                                    template = "https://www.google.com/search";
                                    params = [
                                        { name = "udm"; value = "2"; }
                                        { name = "q"; value = "{searchTerms}"; }
                                    ];
                                }
                            ];
                        };

                        github = {
                            name = "Github";
                            definedAliases = [ "@gh" "@github" ];
                            icon = "https://github.githubassets.com/favicons/favicon-dark.svg";
                            urls = [
                                {
                                    template = "https://github.com/search";
                                    params = [
                                        { name = "type"; value = "repositories"; }
                                        { name = "q"; value = "{searchTerms}"; }
                                    ];
                                }
                            ];
                        };

                        reddit = {
                            name = "Reddit";
                            definedAliases = [ "@rd" "@reddit" ];
                            icon = "https://www.redditstatic.com/shreddit/assets/favicon/192x192.png";
                            urls = [
                                {
                                    template = "https://www.reddit.com/search";
                                    params = [
                                        { name = "q"; value = "{searchTerms}"; }
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
                            icon = "https://mynixos.com/favicon.ico";
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

                userChrome = builtins.readFile (asa-lib.root "/assets/firefox/userChrome.css");
                userContent = builtins.readFile (asa-lib.root "/assets/firefox/userContent.css");
            };
        };
        
        chromium.enable = true;
    };   
}