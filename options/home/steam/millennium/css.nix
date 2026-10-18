{ lib, ... }:
{
  options.css = lib.mkOption {
    type = lib.types.lines;
    default = "";
    example = ''
      :root {
        --millennium-accent: #89b4fa;
      }
    '';
    description = ''
      Custom CSS written to quick.css in programs.steam.millennium.paths.config.
    '';
  };
}
