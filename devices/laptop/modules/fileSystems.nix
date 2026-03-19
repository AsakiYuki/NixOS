{ ... }: {
  fileSystems."/mnt/waydroid" = {
        device = "/home/asakiyuki/.local/share/waydroid/data/media/0";
        fsType = "fuse.bindfs";
        options = [
            "mirror=1000"
            "xattr-none"
            "chmod-ignore"
        ];
    };
}