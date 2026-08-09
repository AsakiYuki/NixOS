{...}: {
  fileSystems = {
    "/mnt/windows" = {
      device = "/dev/disk/by-uuid/0000294D000006E6";
      fsType = "ntfs";
      options = [
        "rw"
        "uid=1000"
        "gid=100"
        "umask=000"
        "nofail"
        "noauto"
        "x-systemd.automount"
        "x-systemd.mount-timeout=30"
      ];
    };
    "/mnt/waydroid" = {
      device = "/home/asakiyuki/.local/share/waydroid/data/media/0";
      fsType = "fuse.bindfs";
      options = [
        "mirror=1000"
        "xattr-none"
        "chmod-ignore"
      ];
    };
    "/mnt/win-efi" = {
      device = "/dev/disk/by-uuid/0000-31FA";
      fsType = "vfat";
      options = ["ro" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=60"];
    };
  };
}
