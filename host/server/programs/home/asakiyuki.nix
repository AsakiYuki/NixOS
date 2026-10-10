{...}: {
  programs = {
    nixvim.enable = true;
    starship.enable = true;
    bash.enable = true;
    fastfetch.enable = true;
    yt-dlp = {
      enable = true;
      output.directory = "PUBLIC/yt-dlp";
    };
  };
}
