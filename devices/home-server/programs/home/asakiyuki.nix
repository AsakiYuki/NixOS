{
  pkgs,
  unstable-pkgs,
  ...
}: {
  programs = {
    cider = {
      enable = true;
      package = pkgs.cider-2;
    };

    vscodium.global.extensions = with unstable-pkgs.vscode-extensions; [
      wakatime
    ];
  };
}
