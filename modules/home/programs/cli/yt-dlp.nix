{config, ...}: let
  cfg = config.programs.yt-dlp.output;
in {
  programs.yt-dlp = {
    settings = {
      output = "${config.home.homeDirectory}/${cfg.directory}/${cfg.format}";
      cookies-from-browser = "firefox";
      format = "bestvideo[format_note*=Premium]+bestaudio/bestvideo[format_id*=sr]+bestaudio/bestvideo+bestaudio/best";
      format-sort = "res,br";
      format-sort-force = true;
    };
  };
}
