{ ... }: {
    services.adguardhome = {
        enable = true;
        port = 26789;
        openFirewall = true;
    };
}
