{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # php btw
    php85
    php85Packages.composer
    intelephense

    lm_sensors
    ryzenadj
    sbctl
    rsync
  ];
}
