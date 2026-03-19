{ ... }: {
    systemd.mounts = [
        {
            what = "/home/asakiyuki/.local/share/waydroid/data/media/0";
            where = "/mnt/waydroid";
            type = "fuse.bindfs";
            options = "mirror=1000";
        }
    ];
}