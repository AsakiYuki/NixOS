{pkgs, ...}: {
  extraPackages = with pkgs; [
    prettier
  ];
}
