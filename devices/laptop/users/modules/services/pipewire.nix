{ ... }: {
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;  
        pulse.enable = true;
        wireplumber.enable = true;

        extraConfig.pipewire."10-fix-sample-rate" = {
            "context.properties" = {
                "default.clock.rate" = 48000;
                "default.clock.allowed-rates" = [ 44100 48000 ];
            };
        };
    };
}