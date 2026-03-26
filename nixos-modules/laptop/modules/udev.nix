{ ... }: {
    services.udev = {
        enable = true;
        extraRules = ''
            KERNEL=="hidraw*", ATTRS{idVendor}=="8089", ATTRS{idProduct}=="0009", GROUP="input", MODE="0660"
        '';
    };
}